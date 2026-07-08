# Solution Output Template

When outputting a loop design solution, ALWAYS use this structure.

---

## 方案：[Task Name]

**推荐 Loop 类型**：[Turn-based / Goal-based / Time-based / Proactive]
**组合**：[primitives used, e.g., `/schedule` + `/goal` + verification skill]

### 为什么选这个组合

[2-3 sentences explaining why this loop type fits the task, referencing the task profile signals: frequency, verifiability, external systems, complexity.]

### 需要的 Skills

| Skill | 状态 | 用途 |
|-------|------|------|
| `skill-name` | ✅ 已安装 / ✗ 需安装 | What it does for this loop |

### 一键运行 Prompt

```
[The complete ready-to-run prompt, including /schedule, /goal, skill references, verification steps, and stop conditions.]
```

### Token 预算估算

- 单次运行：[X-YK tokens]
- 建议先 pilot 跑 [N] 个观察用量
- 用 `/usage` 监控

### 风险提示

- ⚠️ [Risk 1: e.g., "不要让它自动 merge PR，设为创建 PR 等人审"]
- ⚠️ [Risk 2: e.g., "给 /goal 加最大轮次：stop after 10 tries"]

### 下一步

1. [First action: e.g., "安装缺失的 skills"]
2. [Second action: e.g., "用上面的 prompt 启动 loop"]
3. [Third action: e.g., "跑一轮后检查 /usage 确认预算"]

---
