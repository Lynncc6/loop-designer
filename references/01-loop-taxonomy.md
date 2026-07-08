# 01 — Loop Taxonomy: 4 Types of Agent Loops

Based on the Claude Code team's definition: agents repeating cycles of work until a stop condition is met.

---

## Turn-based Loop

**Trigger**: A user prompt each turn.
**Stop**: Claude judges the task is complete or needs more context.
**Best for**: Shorter tasks, exploration, one-off work that isn't part of a regular process.
**Manage by**: Writing specific prompts and improving verification with skills to reduce turns.

This is the default loop. Every time you send a prompt, you start a manual loop where you direct each turn. Claude gathers context, takes action, checks its work, repeats if needed, and responds.

**Example workflow**:
1. You: "Create a like button component"
2. Claude reads the codebase, makes the edit, runs tests
3. Claude hands back something it believes works
4. You manually check, then write the next prompt

**How to improve**: Encode your manual checks into a skill so Claude can self-verify end-to-end.

---

## Goal-based Loop (`/goal`)

**Trigger**: A manual prompt in real-time.
**Stop**: Goal achieved OR maximum number of turns reached.
**Best for**: Tasks with verifiable exit criteria.
**Manage by**: Setting specific completion criteria + explicit turn caps ("stop after 5 tries").

When a single turn isn't enough, agents do better when they can iterate. `/goal` extends how long Claude keeps iterating by defining what "done" looks like. Each time Claude tries to stop, an evaluator checks your condition and sends it back to work until the goal is met or the turn cap is reached.

**Key insight**: Deterministic criteria (number of tests passed, score threshold) work far better than subjective ones.

**Example**:
```
/goal get the homepage Lighthouse score to 90 or above, stop after 5 tries.
```

---

## Time-based Loop (`/loop` and `/schedule`)

**Trigger**: A specified time interval.
**Stop**: You cancel it, or the work completes (PR merges, queue is empty).
**Best for**: Recurring work, or interfacing with external environments/systems.
**Manage by**: Setting longer intervals or reacting to events rather than pure time.

Some work is recurring (summarize Slack every morning) or depends on external systems (a PR that may receive code reviews or fail CI). `/loop` re-runs a prompt on an interval on your machine. `/schedule` moves it to the cloud.

**Example**:
```
/loop 5m check my PR, address review comments, and fix failing CI.
```

---

## Proactive Loop

**Trigger**: An event or schedule, with no human in real-time.
**Stop**: Each sub-task exits when its goal is met. The routine runs until you turn it off.
**Best for**: Recurring streams of well-defined work: bug reports, issue triage, migrations, dependency upgrades.
**Manage by**: Routing routines to smaller/faster models, using the most capable model only for judgment calls.

The most powerful loop type. Composes all primitives:
1. `/schedule` to trigger the routine
2. `/goal` to define what "done" looks like
3. Skills to document how to verify
4. Dynamic workflows to orchestrate agents in parallel
5. Auto mode so it runs without asking for permission

**Example**:
```
/schedule every hour: check the project-feedback channel for bug reports.
/goal: don't stop until every report found this run is triaged, actioned, and responded to.
When fixing a bug, use a workflow to explore three solutions in parallel worktrees
and have a judge adversarially review them.
```

---

## Comparison Table

| | Turn-based | Goal-based | Time-based | Proactive |
|---|---|---|---|---|
| **You hand off** | The check | The stop condition | The trigger | The prompt |
| **Use when** | Exploring, deciding | You know what done looks like | Work happens on a schedule | Work is recurring & well-defined |
| **Reach for** | Custom verification skills | `/goal` | `/loop`, `/schedule` | All of the above + workflows |
| **Human in loop** | Every turn | At definition, not execution | At definition | Minimal/none |
| **Complexity** | Low | Medium | Medium | High |
