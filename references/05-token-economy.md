# 05 — Token Economy: Managing Costs

Loops that run autonomously can burn tokens fast. Here's how to keep it under control.

---

## Cost Drivers (ordered by impact)

1. **Workflows / sub-agents** — each spawned agent gets its own context window. 10 sub-agents × 100K tokens = 1M tokens per run.
2. **Long contexts** — feeding entire codebases or logs into every iteration.
3. **Unbounded retries** — no stop cap means the agent keeps trying.
4. **Frequent scheduling** — `/loop 1m` × 24h = 1,440 runs per day.

---

## Budget Controls

### 1. Choose the right model for the job
- **Routine work** (sorting, formatting, simple checks) → smaller, faster models
- **Judgment calls** (which solution is better, is this correct?) → most capable model
- Don't use GPT-5 to alphabetize a list.

### 2. Define clear stop criteria
Vague goals = more iterations = more tokens. "Lighthouse ≥ 90" is 1-3 tries. "Make the page fast" could be 20.

### 3. Pilot before scaling
- Run the loop on 3 items before running on 300.
- Check `/usage` to see where tokens are going.
- Use `/goal` (no args) to see turns and token usage so far.

### 4. Use scripts for deterministic work
Running `./scripts/fill-pdf.sh` is 100x cheaper than having the agent reason through PDF form filling each time. Ship scripts in your skill.

### 5. Match interval to change frequency
- If your CI runs every 15 min, don't check it every minute.
- If your Slack channel gets 5 messages/day, don't summarize every hour.

---

## Monitoring

| Command | What it tells you |
|---------|-----------------|
| `/usage` | Breakdown by skills, sub-agents, MCPs |
| `/goal` (no args) | Turns used + tokens so far for current goal |
| `/workflows` | Per-agent token usage for active workflows |

---

## Budget Template

When designing a loop, estimate and document:

```
Estimated tokens per run:
- Single agent task: 20-50K
- With verification: 50-100K
- With workflow (3 sub-agents): 150-300K
- Proactive loop (schedule + workflow + goal): 300K-1M

Recommended safeguards:
- [ ] Max turns set in /goal
- [ ] Item cap for batch processing
- [ ] Interval ≥ minimum useful frequency
- [ ] Smaller model for routine sub-tasks
- [ ] Pilot run completed and usage reviewed
```
