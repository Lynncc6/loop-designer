# 03 — Verification Design: The Most Important Chapter

A loop's output quality depends entirely on how well the agent can verify its own work.
If you only read one chapter, read this one.

---

## Why Verification Matters

Without verification, an agent is like a developer who writes code but never runs it. It will confidently hand you broken work and declare it done.

The goal of verification design: **give the agent the same tools a human reviewer would use to check the work**.

---

## The Verification Spectrum

| Level | Method | Example | Reliability |
|-------|--------|---------|-------------|
| L0 | Agent's own judgment | "The code looks correct" | Very low |
| L1 | Static checks | `eslint`, `tsc`, type checking | Low |
| L2 | Automated tests | `npm test`, `pytest` | Medium |
| L3 | Runtime observation | Start server, hit endpoints, check responses | High |
| L4 | Interactive testing | Browser interaction, click flows, screenshot diff | Very high |
| L5 | Second-agent review | Adversarial reviewer with fresh context | Highest |

**Rule**: Always push your verification as far right on this spectrum as you can afford.

---

## Designing a Verification Skill

A verification skill is a `SKILL.md` that encodes exactly how to check the work. Structure:

```markdown
---
name: verify-frontend-change
description: Verify any UI change end-to-end before declaring it done.
---

# Verifying Frontend Changes

Never report a UI change as complete based on a successful edit alone.
Verify it the way a human reviewer would:

1. Start the dev server and open the edited page in the browser.

2. Interact with the change directly. For a new control (button, input, toggle):
   click it, confirm the expected state change, and screenshot before/after.

3. Check the browser console: zero new errors or warnings.

4. Run Lighthouse audit and confirm no regressions.

5. Run the test suite: `npm test` must exit 0.

If any step fails, fix the issue and rerun from step 1.
Do not hand back partially verified work.
```

---

## Verification Design Principles

### 1. Make it quantitative
- "Page loads in < 2s" ✅
- "Page feels fast" ❌

### 2. Make it executable
- "Run `npm test` and check exit code" ✅
- "Make sure tests pass" ❌ (agent might skip or misread)

### 3. Make it comprehensive
Don't just check "does it run" — check "does it work correctly in the ways users will actually use it":
- Happy path ✅
- Edge cases (empty input, max input, invalid input)
- Error paths (network failure, permission denied)
- Side effects (did it break something else?)

### 4. Make it iterative
If verification fails → fix → re-verify from the beginning. Don't just re-check the failing step.

### 5. Use tools, not reasoning
Whenever possible, give the agent a **tool** (script, command, MCP) rather than asking it to **reason** about correctness:
- "Run `./scripts/check-accessibility.sh`" > "Check if the page is accessible"
- "Use the browser MCP to click the button" > "Imagine clicking the button"

---

## Common Verification Gaps

| Scenario | What most agents do | What they should do |
|----------|-------------------|-------------------|
| UI change | "I edited the CSS" | Start server, open browser, interact, screenshot |
| API change | "I updated the endpoint" | Actually call the endpoint with curl and check response |
| Refactor | "Tests pass" | Tests pass + check no behavior change via integration tests |
| Bug fix | "I added a null check" | Write a test that reproduces the bug, confirm it now passes |
| Config change | "Updated the YAML" | Actually start the service and confirm it boots correctly |
