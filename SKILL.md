---
name: loop-designer
description: Design agent loops for any task. Recommends the right loop type (turn-based, goal-based, time-based, proactive), matches skills & workflows, and outputs a ready-to-run prompt. Use when user asks "how to automate X", "design a loop for Y", "what /goal or /schedule should I use", or mentions loop design.
version: 0.1.0
metadata:
  author: "loop-designer skill"
  tags: [agent, loop, automation, goal, schedule, workflow]
---

# Loop Designer

Design better agent loops, faster.

## What this skill does

1. **Parses your goal** — what task you want automated, how often, what "done" looks like
2. **Recommends the loop type** — turn-based, goal-based, time-based, or proactive
3. **Finds matching skills** — scans local installed skills + curated catalog
4. **Outputs a complete solution** — ready-to-run prompt, required skills, token budget, risks

## Quick start

Just tell me what you want to automate. Examples:

- "I want to auto-handle PR reviews and CI fixes"
- "How do I set up a loop to optimize our Lighthouse score?"
- "Design a proactive loop for triaging incoming bug reports"
- "What's the best way to auto-summarize Slack messages every morning?"

## How I work

### Step 1: Parse the task

I extract a **task profile** from your description:

| Signal | What it tells me |
|--------|-----------------|
| Frequency (once/daily/hourly/event-driven) | Loop trigger type |
| External systems (GitHub/Slack/email/CI) | Need for MCPs or integrations |
| Verifiable exit criteria? | Can we use `/goal`? |
| Human judgment needed? | Turn-based vs autonomous |
| Complexity (steps, files, decisions) | Single agent vs workflow |

### Step 2: Pick the loop type

Use this decision tree:

```
Task to automate?
│
├─ Repeats on a schedule?
│   ├─ Yes, fixed interval → Time-based (/loop or /schedule)
│   ├─ Yes, event-driven → Proactive (schedule + goal + workflow)
│   └─ No, one-time → continue
│
├─ "Done" is measurable?
│   ├─ Yes (tests pass / score ≥ X / file exists) → Goal-based (/goal)
│   └─ No, needs human eyes → Turn-based + verification skill
│
└─ Complexity?
    ├─ Simple (<10 steps) → Turn-based is fine
    └─ Complex / parallel exploration needed → Turn-based + skills + consider workflow
```

### Step 3: Match skills

I scan:
- **Local**: `~/.codex/skills/`, `~/.agents/skills/`
- **Catalog**: `references/07-skill-catalog.md` (curated by scenario)

Then score each skill against the task profile and return the top matches.

### Step 4: Output the solution

Format defined in `templates/solution-output.md`. Always includes:
- Loop type recommendation + why
- Required skills (installed + to-install)
- Ready-to-run prompt
- Token budget estimate
- Risk warnings

## Loop types at a glance

| Type | Trigger | Stop | Best for | Primitive |
|------|---------|------|----------|-----------|
| Turn-based | User prompt each turn | Claude judges done | Exploration, one-off tasks | Skills (self-verify) |
| Goal-based | `/goal` command | Criteria met OR max turns | Tasks with measurable exit | `/goal` |
| Time-based | `/loop` or `/schedule` | User cancels or task completes | Recurring work, external systems | `/loop`, `/schedule` |
| Proactive | Event/schedule, no human | Each sub-goal met | Well-defined recurring streams | All above + workflows + auto mode |

## Key principles

1. **Not everything needs a complex loop** — start with turn-based, upgrade only when needed
2. **Verification > execution** — the quality of a loop depends on how well it can check its own work
3. **Quantifiable > fuzzy** — "tests pass" beats "looks good" every time
4. **Improve the system, not the instance** — when a single result is bad, encode the fix so all future iterations benefit
5. **Compose, don't monolith** — the strongest loops are `/schedule` + `/goal` + skills + workflows working together

## When NOT to automate

Recommend the user stay manual when:
- The task requires deep human judgment that can't be verified
- The cost of a wrong answer is very high (production deploys, security decisions)
- The task changes so often that maintaining the loop costs more than doing it manually

## File map

- `references/01-loop-taxonomy.md` — deep dive on all 4 loop types
- `references/02-stop-conditions.md` — how to design good stop conditions
- `references/03-verification-design.md` — the most important chapter: self-verification
- `references/04-loop-composition.md` — combining primitives, upgrade path from simple to complex
- `references/05-token-economy.md` — managing token costs
- `references/06-debugging-loops.md` — what to do when loops stall, loop forever, or go off-track
- `references/07-skill-catalog.md` — curated skills index by scenario
- `templates/` — templates for goals, verification skills, solution output
- `solutions/` — pre-built solutions for common scenarios
- `scripts/scan-local-skills.sh` — scan installed skills on this machine
