# 方案：每日 Slack 消息摘要

**场景**：你不想错过重要讨论，但也没空翻几百条 Slack 消息。

**推荐 Loop 类型**：Time-based (`/schedule`)
**组合**：`/schedule` + slack-mcp + summarize skill

---

## 为什么选这个组合

- 任务是**严格周期性的**（每天早上）→ `/schedule` 是最佳选择
- 输入是**外部系统**（Slack 频道）→ 需要 MCP 对接
- 输出是**格式化的摘要** → 不需要复杂决策，只需要好的总结能力
- 不需要 `/goal`——因为"完成"就是"发完摘要"，没有可迭代的目标

## 需要的 Skills

| Skill | 状态 | 用途 |
|-------|------|------|
| `slack-mcp` | ✗ 需安装 | 读取 Slack 频道消息 |
| `summarize` | ✅ 内置 | 总结消息内容 |
| `lark-im` | ✗ 需安装 | 把摘要发到飞书（可选） |
| `baoyu-post-to-x` | ✗ 需安装 | 把摘要发到 X（可选） |

## 一键运行 Prompt

```
/schedule every weekday at 9am:

1. Read messages from these Slack channels since 9am yesterday:
   - #engineering
   - #product
   - #design
   - #bugs

2. For each channel, produce a structured summary:
   - 📌 重要决策（有结论的讨论）
   - 🔴 需要关注的问题（bug、阻塞、风险）
   - 💡 新想法和提案（还没结论但值得知道）
   - 📋 进行中的事项（谁在做什么、进展如何）

3. Cross-reference: if the same topic appears in multiple channels,
   merge into one entry and note all channels involved.

4. Format the summary as:
   ## [日期] 每日摘要
   
   ### 📌 重要决策
   - [决策内容] — #频道, 发言人
   
   ### 🔴 需要关注
   - [问题描述] — #频道, 状态: [未解决/处理中/已解决]
   
   ### 💡 新想法
   - [想法摘要] — #频道, 发起人
   
   ### 📋 进行中
   - [事项] — #频道, 负责人, 状态

5. Send the summary to:
   - My DMs on Slack
   - (Optional) #daily-summary channel
   - (Optional) My Lark DMs via lark-im skill
```

## Token 预算估算

- 每次运行：20-80K tokens（取决于消息量）
- 每天一次，每月约 22 天 → 440K-1.76M tokens/月

## 风险提示

- ⚠️ 消息量可能很大——先限制读取条数（如"每个频道最多 200 条"）
- ⚠️ 敏感信息不要自动摘要到公共频道——默认只发 DM
- ⚠️ 周末不要发（`every weekday` 而不是 `every day`）
- ⚠️ 如果某天消息为 0（假期），发一条"今日无新消息"而不是报错

## 进阶：按人定制摘要

```
/schedule every weekday at 9am:

For each team member who opted in:
  1. Read channels they care about (from their config)
  2. Filter for topics they follow (keyword matching)
  3. Highlight messages where they were @mentioned
  4. Send personalized summary to their DM
```
