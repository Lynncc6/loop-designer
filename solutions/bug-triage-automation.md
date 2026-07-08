# 方案：Bug 反馈自动 Triage + 修复

**场景**：用户在 Slack/GitHub Issues 提交 bug，你不想手动一个个看。

**推荐 Loop 类型**：Proactive
**组合**：`/schedule` + `/goal` + workflow + skills

---

## 为什么选这个组合

- Bug 反馈是**持续流入的事件流** → 需要 `/schedule` 定时捞取
- 每个 bug 有**明确的处理标准**（分类、分配、回复）→ 可以用 `/goal` 定义完成
- 修复可能需要**并行探索多个方案** → 需要 workflow
- 处理流程**定义清晰且重复** → 适合无人值守

## 需要的 Skills

| Skill | 状态 | 用途 |
|-------|------|------|
| `github-mcp` | ✗ 需安装 | 读取/创建 Issue，创建 PR |
| `slack-mcp` | ✗ 需安装 | 读取 Slack 频道消息 |
| `code-review` | ✅ 内置 | 审查修复质量 |
| `test-verifier` | ✗ 需安装 | 确认修复通过测试 |
| `lark-task` | ✗ 需安装 | 创建飞书任务分配给人（可选） |

## 一键运行 Prompt

```
/schedule every hour: check the #bug-reports channel (Slack) and
new GitHub issues labeled "bug".

/goal: don't stop until every new report found this run is triaged,
actioned, and responded to. Max 10 reports per run.

For each bug report:
  1. Triage: read the report, determine if it's a real bug.
     - If not a bug: label "question" and respond asking for clarification.
     - If real bug: continue.

  2. Reproduce: use code-search to find relevant code, try to reproduce.
     - If can't reproduce: respond asking for more details, label "needs-repro".
     - If reproduced: continue.

  3. Fix: spawn a workflow with 3 fixer agents in parallel worktrees:
     - Fixer A: minimal fix (patch the symptom)
     - Fixer B: root cause fix
     - Fixer C: defensive fix (add guards + tests)
     - Judge agent: adversarially review all 3, pick the best.

  4. Verify: run test-verifier on the chosen fix.
     - Add a regression test that specifically covers this bug.

  5. Create PR (do NOT auto-merge):
     - PR description includes: bug report link, root cause, fix approach, test added.
     - Request review from the team.

  6. Respond to the original reporter:
     - "Thanks for reporting! Root cause was X. Fix in PR #Y. Should be live by Z."

Use auto mode. Use code-review skill on the final fix before creating PR.
If a bug takes more than 5 tries to fix, escalate to human and stop.
```

## Token 预算估算

- 每个 bug：100-300K tokens（探索 + 修复 + 验证 + 评审）
- 每小时跑一次，每次最多 10 个 → 1-3M tokens/run（峰值）
- **建议先 pilot 跑 3 个 bug 观察用量**

## 风险提示

- ⚠️ **绝对不要自动 merge PR**——只创建，等人审
- ⚠️ 给每个 bug 加最大尝试次数（5次），防止一个难 bug 阻塞整个 batch
- ⚠️ 对于安全相关的 bug，直接标记 `escalate-to-human`，不让 agent 自己修
- ⚠️ 第一次跑先把 schedule 间隔设大（每 6 小时），稳定后再缩短

## 降级方案（如果 workflow 不可用）

去掉并行修复，改成单 agent 串行：
```
/schedule every 2h: check new bugs.
/goal: triage and respond to all new reports. Max 5 per run.
For each: reproduce, fix minimally, add test, create PR.
```
