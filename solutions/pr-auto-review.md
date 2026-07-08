# 方案：PR 自动 Review + CI 修复

**场景**：你提交了 PR，不想手动盯着 CI 和 review comments。

**推荐 Loop 类型**：Time-based (`/loop`)
**组合**：`/loop` + 验证 skills + github-mcp

---

## 为什么选这个组合

- PR 状态变化是**外部事件驱动**的（有人评论、CI 跑完）→ 需要定时检查
- 每次检查的**动作明确**（修 CI、回评论）→ 不需要复杂决策
- 任务**有自然终止条件**（PR merge 或关闭）→ 不会无限跑

## 需要的 Skills

| Skill | 状态 | 用途 |
|-------|------|------|
| `/code-review` | ✅ 内置 | 审查自己的代码变更 |
| `github-mcp` | ✗ 需安装 | 读取 PR 评论、CI 状态、提交修复 |
| `test-verifier` | ✗ 需安装 | 本地跑测试确认修复有效 |
| `lint-fixer` | ✗ 需安装 | 自动修复 lint 错误 |

## 一键运行 Prompt

```
/loop 5m check my PR (#123 or paste URL):

1. Check CI status via github-mcp. If failing:
   - Read the failure logs
   - Fix the issue locally
   - Run test-verifier to confirm
   - Push the fix

2. Check for new review comments via github-mcp:
   - If actionable (bug report, requested change): fix and push
   - If question: respond with explanation
   - If nit/style: use lint-fixer to auto-fix

3. Check if PR has all required approvals and CI is green:
   - If yes: post a comment "Ready to merge" and stop the loop
   - If no: continue monitoring

Stop conditions: PR is merged OR closed OR you manually stop.
```

## Token 预算估算

- 每次循环：10-30K tokens
- 典型 PR 生命周期：5-15 次循环
- 总计：50K-450K tokens

## 风险提示

- ⚠️ 不要让它自动 merge，只让它修复和评论
- ⚠️ 对于需要架构判断的 review comments，让它回复"已记录，等人确认"而不是自己改
- ⚠️ 设最小间隔 5 分钟，别设 1 分钟——CI 不会那么快变

## 进阶：升级到 Proactive

当你有多个 PR 要管理时：
```
/schedule every 15m: check all open PRs I'm assigned to.
For each: address review comments and fix CI.
/goal: don't stop until every PR is green and approved.
Use code-review skill before pushing any fix.
Max 3 PRs per run.
```
