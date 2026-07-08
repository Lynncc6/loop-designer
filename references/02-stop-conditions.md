# 02 — Stop Conditions: How to Define "Done"

The single most important design decision for any loop: when does it stop?

---

## Three Principles of Good Stop Conditions

### 1. Quantifiable, not subjective

| Bad (subjective) | Good (quantifiable) |
|---|---|
| "The page is fast" | "Lighthouse performance score ≥ 90" |
| "Tests pass" | "`npm test` exits with code 0 and 0 failures" |
| "The bug is fixed" | "The specific test case `test_bug_123` passes" |
| "Code looks good" | "`eslint` reports 0 errors + `tsc` passes + all tests green" |

### 2. Bounded, not infinite

Always add a maximum iteration count:

```
# Good
/goal fix all failing tests, stop after 5 tries.

# Bad (can loop forever)
/goal fix all failing tests.
```

Why? Because sometimes the agent hits a problem it genuinely can't solve. Without a bound, it will keep trying, burning tokens.

### 3. Detectable by the agent

The agent must be able to check the condition itself. If "done" requires a human to look at it, you can't use `/goal` — use turn-based + a verification skill instead.

---

## Stop Condition Patterns

### Pattern A: Single Metric
```
/goal get Lighthouse score above 90, stop after 5 tries.
```
Works when one number captures success.

### Pattern B: Checklist
```
/goal verify the PR is ready:
1. All CI checks pass
2. No unresolved review comments
3. At least 1 approval
4. No merge conflicts
Stop after 3 tries.
```
Works when "done" means several things are all true.

### Pattern C: Queue Empty
```
/goal process all items in the inbox until it's empty.
Max 20 items per run.
```
Works for triage, inbox processing, etc. Always cap the number of items.

### Pattern D: Convergence
```
/goal optimize the query until the execution plan stops improving.
Stop after 3 iterations with no improvement, or 10 total.
```
Works for optimization tasks where "better" is measurable but "best" is unknown.

---

## Anti-patterns

- **"Until it's perfect"** — no agent can verify perfection
- **"Until I say stop"** — defeats the purpose of autonomous loops
- **No upper bound** — guaranteed to eventually waste tokens
- **Too many conditions** — if your stop condition is a 20-item checklist, the agent will lose focus. Break it into smaller goals.
