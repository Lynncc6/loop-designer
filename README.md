# 🎯 Loop Designer

> 给 agent 设计好 loop，而不是给它写 prompt。

## 这是什么

一个帮你**设计 agent 自动化工作流**的 skill。你告诉它你想自动化什么，它给你一套完整的方案：用哪种 loop、配哪些 skills、一键运行的 prompt 怎么写、token 预算多少、有什么风险。

## 解决什么问题

市面上有很多 skill，但没有人告诉你**怎么把它们组合起来用**。Loop Designer 填补了这个空白：

- ❓ "我这个任务该用 `/goal` 还是 `/loop`？"
- ❓ "怎么让 agent 自己检查自己的活？"
- ❓ "有哪些现成的 skill 能配合这个任务？"
- ❓ "怎么防止 agent 死循环烧 token？"
- ❓ "PR review / bug triage / Lighthouse 优化这些常见场景有没有现成方案？"

## 四种 Loop，一张图看懂

| 类型 | 触发方式 | 停止条件 | 适用场景 | 原语 |
|------|---------|---------|---------|------|
| **Turn-based** | 你每轮发 prompt | Agent 判断完成 | 探索、一次性任务 | Skills（自验证） |
| **Goal-based** | `/goal` 命令 | 目标达成 or 达到最大轮次 | 有可量化退出标准的任务 | `/goal` |
| **Time-based** | `/loop` 或 `/schedule` | 你取消 or 任务完成 | 周期性工作、对接外部系统 | `/loop`, `/schedule` |
| **Proactive** | 事件/日程，无人值守 | 每个子任务达成目标即停 | 定义清晰的重复性工作流 | 以上全部 + workflows + auto |

> **最强的 loop 是组合**：`/schedule` + `/goal` + skills + workflows

## 快速开始

直接描述你想自动化的任务：

```
"帮我设计一个自动处理 PR review 的 loop"
"我想让 agent 每天早上总结 Slack 消息"
"怎么用 loop 把首页 Lighthouse 分数干到 90+"
"设计一个 bug 反馈自动 triage 系统"
```

Skill 会输出：

```
📋 方案：PR 自动 Review + CI 修复

推荐类型：Time-based (/loop)
组合：/loop + github-mcp + code-review + test-verifier

为什么选这个：
- PR 状态变化是外部事件 → 需要定时检查
- 动作明确（修 CI、回评论）→ 不需要复杂决策
- 有自然终止（PR merge）→ 不会无限跑

需要的 Skills：
  ✓ /code-review (内置)        审查代码变更
  ✗ github-mcp (需安装)        读取 PR 评论和 CI 状态
  ✗ test-verifier (需安装)      跑测试确认修复

一键运行 Prompt：
──────────────────────────────
/loop 5m check my PR (#123):
  1. Check CI status. If failing → read logs → fix → push.
  2. Check review comments. If actionable → fix and push.
  3. If CI green + approved → post "Ready to merge" and stop.
──────────────────────────────

Token 预算：每次循环 10-30K，典型 PR 生命周期 50K-450K
风险提示：
  ⚠️ 不要自动 merge，只修和评
  ⚠️ 架构判断类评论让人来，别让 agent 自己改
  ⚠️ 最小间隔 5 分钟
```

## 内置方案库

开箱即用，不用从零配：

| 方案 | Loop 类型 | 一句话 |
|------|----------|--------|
| [PR 自动 Review](solutions/pr-auto-review.md) | Time-based | 每 5 分钟查 PR，修 CI、回评论 |
| [Bug 自动 Triage](solutions/bug-triage-automation.md) | Proactive | 每小时捞 bug → 复现 → 并行修 3 个方案 → 评审选最优 → 发 PR |
| [Lighthouse 优化](solutions/lighthouse-optimizer.md) | Goal-based | 迭代优化直到分数 ≥ 90，不行就回滚 |
| [每日 Slack 摘要](solutions/daily-slack-summary.md) | Time-based | 每天 9 点自动总结频道消息发你 DM |
| [依赖自动升级](solutions/dependency-upgrade.md) | Proactive | 每周一凌晨自动升级 patch/minor 依赖，跑测试，发 PR 等人审 |

## 工作原理

```
用户描述任务
    │
    ▼
┌─────────────────────┐
│  任务画像解析          │  提取：频率、外部依赖、可验证性、复杂度
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│  Loop 类型推荐        │  决策树匹配 4 种 loop 类型
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│  Skills 匹配          │  扫描本地 80+ skills + 目录索引
└─────────────────────┘
    │
    ▼
┌─────────────────────┐
│  完整方案输出          │  类型 + 理由 + Skills + Prompt + 预算 + 风险
└─────────────────────┘
```

## 核心原则

1. **不是所有任务都需要复杂 loop** — 从 turn-based 开始，按需升级
2. **验证 > 执行** — loop 的输出质量取决于自验证能力
3. **可量化 > 模糊** — "测试通过"比"看起来不错"靠谱 100 倍
4. **系统改进 > 单次修复** — 一个结果不好，编码进系统让所有迭代受益
5. **组合 > 单一** — schedule + goal + skills + workflows 才是终极形态

## 目录结构

```
loop-designer/
├── README.md                          ← 你在这里
├── SKILL.md                           ← Skill 主入口（agent 读这个）
├── references/
│   ├── 01-loop-taxonomy.md            ← 4 种 loop 详解
│   ├── 02-stop-conditions.md          ← 停止条件怎么设计
│   ├── 03-verification-design.md      ← ⭐ 最核心：自验证机制
│   ├── 04-loop-composition.md         ← 从简单到复杂的升级路径
│   ├── 05-token-economy.md            ← token 预算控制
│   ├── 06-debugging-loops.md          ← Loop 调试手册
│   └── 07-skill-catalog.md            ← 30+ skills 按场景索引
├── templates/
│   ├── solution-output.md             ← 方案输出格式
│   ├── goal-template.md               ← /goal 定义模板
│   ├── skill-verification.md          ← 验证 skill 模板
│   └── proactive-loop.md              ← Proactive loop 模板
├── solutions/
│   ├── pr-auto-review.md              ← PR 自动 review
│   ├── bug-triage-automation.md       ← Bug 自动 triage
│   ├── lighthouse-optimizer.md        ← Lighthouse 优化
│   ├── daily-slack-summary.md         ← 每日 Slack 摘要
│   └── dependency-upgrade.md          ← 依赖自动升级
└── scripts/
    └── scan-local-skills.sh           ← 扫描本地已装 skills
```

## 安装

```bash
# 方式 1：放到 codex skills 目录（推荐）
mv loop-designer ~/.codex/skills/

# 方式 2：放到 agents skills 目录
mv loop-designer ~/.agents/skills/
```

安装后，在对话中提到 "loop"、"自动化"、"/goal"、"/schedule" 等关键词即可触发。

## 致谢

Loop 类型定义基于 [@delba_oliveira / Claude Code 团队的官方文章](https://x.com/ClaudeDevs/status/2074208949205881033)。

---

*把信息按"结论摘要 → 可筛选的概览 → 逐条明细"三层重排，让颜色只为"信号"服务。* — 不，这是另一个项目的 😄
