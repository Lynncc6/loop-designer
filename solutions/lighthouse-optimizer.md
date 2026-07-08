# 方案：Lighthouse 跑分优化

**场景**：你想把首页 Lighthouse 分数干到 90+，但不想手动一次次跑。

**推荐 Loop 类型**：Goal-based (`/goal`)
**组合**：`/goal` + 验证 skill + browser-mcp

---

## 为什么选这个组合

- 目标**完全可量化**（Lighthouse 分数）→ `/goal` 的最佳用例
- 每次迭代**有明确的反馈信号**（分数升了还是降了）→ agent 能自主判断方向
- 是**一次性任务**（优化到目标就停）→ 不需要 schedule
- 可能需要**多轮迭代**（压缩图片、拆 bundle、懒加载…）→ 需要 loop

## 需要的 Skills

| Skill | 状态 | 用途 |
|-------|------|------|
| `lighthouse-audit` | ✗ 需安装 | 运行 Lighthouse 并返回分数 |
| `verify-frontend-change` | ✗ 需安装 | 确认优化没破坏功能 |
| `browser-mcp` | ✗ 需安装 | 浏览器交互验证 |
| `baoyu-compress-image` | ✗ 需安装 | 自动压缩图片（可选） |

## 一键运行 Prompt

```
/goal get the homepage Lighthouse performance score to 90 or above.
Stop after 8 tries, or after 3 consecutive tries with no improvement.

Process for each iteration:
  1. Run lighthouse-audit on the homepage.
     - Record all 4 scores: performance, accessibility, best-practices, SEO.
     - Read the "opportunities" and "diagnostics" sections.

  2. Pick the highest-impact fix from opportunities:
     - If images are unoptimized: use baoyu-compress-image to compress them,
       or convert to WebP/AVIF.
     - If JS is blocking render: add defer/async or code-split.
     - If render-blocking CSS: inline critical CSS, defer the rest.
     - If unused JS: tree-shake or lazy-load that component.
     - If server response is slow: investigate caching or CDN.

  3. Make the change.

  4. Run verify-frontend-change to confirm nothing broke:
     - Start dev server, open homepage in browser.
     - Confirm all interactive elements still work.
     - Check console for errors.

  5. Run lighthouse-audit again.
     - If score improved: keep the change, go to next iteration.
     - If score didn't improve or got worse: revert the change, try next opportunity.

  6. After each iteration, log: what was tried, score before/after, kept or reverted.

When done (target met or gave up), output a summary:
- Final scores
- Changes that were kept (with file paths)
- Changes that were tried and reverted
- Remaining opportunities for future improvement
```

## Token 预算估算

- 每次迭代：30-60K tokens（审计 + 分析 + 修改 + 验证）
- 最多 8 次迭代：240K-480K tokens
- 典型情况：3-5 次迭代就能到 90+

## 风险提示

- ⚠️ 确保优化只针对**性能**，不要为了分数牺牲功能（verify-frontend-change 就是干这个的）
- ⚠️ 有些优化需要后端配合（CDN、缓存），agent 可能做不了——让它识别并跳过
- ⚠️ Lighthouse 分数有 ±3 的波动，不要因为一次微降就回滚——设一个阈值（如"下降 >5 才回滚"）

## 进阶：多页面批量优化

```
/goal get ALL these pages to Lighthouse 90+:
- / (homepage)
- /pricing
- /docs
- /blog

For each page, run the optimization loop above.
Stop after 5 tries per page.
Output a per-page summary at the end.
```
