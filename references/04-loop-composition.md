# 04 — Loop Composition: From Simple to Complex

The strongest loops are compositions of multiple primitives working together.
This chapter shows how to combine them and when to upgrade.

---

## The Upgrade Path

Don't start with a proactive loop. Start simple and upgrade only when the task demands it.

```
Level 1: Turn-based
  You prompt, agent works, you check, you prompt again.
  Good for: exploration, one-off tasks, figuring out what you want.
  ↓ Upgrade when: you're repeating the same prompts and checks.

Level 2: Turn-based + Verification Skill
  Agent can now check its own work end-to-end.
  Good for: tasks where "done" is clear but you still want final review.
  ↓ Upgrade when: you find yourself saying "keep going until X".

Level 3: Goal-based (/goal)
  You define "done" with quantifiable criteria, agent iterates autonomously.
  Good for: optimization, fixing, building to a spec.
  ↓ Upgrade when: this task needs to happen on a schedule.

Level 4: Time-based (/loop or /schedule)
  Task runs on an interval without you triggering it.
  Good for: monitoring, recurring checks, external system integration.
  ↓ Upgrade when: each run spawns multiple sub-tasks that need coordination.

Level 5: Proactive
  schedule + goal + skills + workflows + auto mode.
  Good for: well-defined recurring work streams (bug triage, PR review, migrations).
```

---

## Composition Patterns

### Pattern A: Schedule + Goal (most common)
```
/schedule every hour: /goal process all new items in the queue.
```
- Schedule decides WHEN to run
- Goal decides WHEN to stop
- Together: autonomous recurring work with clear boundaries

### Pattern B: Goal + Verification Skill
```
/goal get Lighthouse to 95. Use verify-frontend-change skill after each edit.
```
- Goal provides the "what" (target score)
- Skill provides the "how to check" (end-to-end verification)
- Together: autonomous iteration with quality gates

### Pattern C: Schedule + Workflow + Goal
```
/schedule every 6h: for each new issue, use a workflow to:
  1. Triage the issue (agent A)
  2. If it's a bug, assign to a fixer (agent B)
  3. /goal: don't stop until all new issues are triaged.
```
- Schedule triggers the batch
- Workflow parallelizes the work across sub-agents
- Goal ensures completeness
- Together: scalable autonomous operations

### Pattern D: Proactive Full Stack
```
/schedule every hour: check #bug-reports channel.
For each new report, spawn a workflow:
  - Explorer agent: reproduce the bug and identify root cause
  - Fixer agent (×3 in parallel worktrees): implement three solutions
  - Judge agent: adversarially review all three and pick the best
/goal: don't stop until every report this run is triaged, actioned, and responded to.
Use auto mode. Use code-review skill on the final fix before creating PR.
```
This is the "full power" composition. Use only for well-understood, high-volume tasks.

---

## Rules for Composition

1. **Add one layer at a time** — don't jump from turn-based to proactive in one step.
2. **Each layer should solve a specific pain point** — don't add `/schedule` "just in case".
3. **Verification must be in place before autonomy** — never let an agent run unsupervised if it can't check its own work.
4. **Monitor token usage as you scale** — workflows can spawn hundreds of agents. Pilot with 3 items before running on 300.
5. **Keep the human override accessible** — even proactive loops should have a clear "stop" button and a way to review results.

---

## When NOT to Compose

- If the task takes < 5 minutes manually, a complex loop will cost more to maintain than it saves.
- If the task changes every time, your loop primitives will keep breaking.
- If verification is impossible (purely creative or judgment-based work), composition doesn't help.
