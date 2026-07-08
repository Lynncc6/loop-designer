# 06 — Debugging Loops: When Things Go Wrong

Loops fail in predictable ways. Here's the diagnosis manual.

---

## Symptom 1: Stops too early (premature termination)

**Cause**: Agent thinks it's done, but the work is actually incomplete.

**Diagnosis**:
- Is the stop condition too vague? "Fix the bug" → agent makes one change and declares victory.
- Is verification missing or too weak? Agent checks "does the file exist" instead of "does the test pass".

**Fix**:
1. Tighten the stop condition: make it quantifiable and multi-step.
2. Add a verification skill with concrete checks.
3. Use `/goal` with an explicit checklist instead of turn-based.

---

## Symptom 2: Loops forever (no convergence)

**Cause**: Agent keeps trying the same thing or can't reach the goal.

**Diagnosis**:
- Is the goal actually achievable? "Get Lighthouse to 100" on a page with 3rd-party ads may be impossible.
- Is the agent repeating the same action? It may be stuck in a local minimum.
- Is there no max-turn cap?

**Fix**:
1. Always add `stop after N tries`.
2. Make the goal slightly easier: "90" instead of "100".
3. Add a "give up and report" condition: "If 3 consecutive attempts don't improve, summarize what you tried and stop."
4. Use a workflow to explore multiple approaches in parallel instead of serial trial-and-error.

---

## Symptom 3: Goes off-track (scope creep)

**Cause**: Agent starts doing things unrelated to the original goal.

**Diagnosis**:
- Is the goal well-bounded? "Improve the app" invites infinite scope.
- Is the agent finding "related" issues and fixing them?

**Fix**:
1. Narrow the goal: "Fix the login button on the settings page" not "Improve UX".
2. Add explicit boundaries: "Only modify files in `src/components/login/`".
3. Use a verification skill that checks "did you touch anything outside scope?"

---

## Symptom 4: Output quality is low

**Cause**: Agent produces work that technically meets the stop condition but is bad.

**Diagnosis**:
- Is the stop condition gaming-able? "Tests pass" can be achieved by deleting tests.
- Is verification too shallow? Only checking L1 (static) not L3+ (runtime).
- Is there no adversarial review?

**Fix**:
1. Strengthen verification: add runtime checks, interactive tests.
2. Add a second-agent reviewer: "Have another agent with fresh context review this."
3. Make the stop condition harder to game: add quality metrics, not just pass/fail.

---

## Symptom 5: Token explosion

**Cause**: Loop costs more than expected.

**Diagnosis**:
- Check `/usage` — where are tokens going?
- Is a workflow spawning too many sub-agents?
- Is the interval too frequent?

**Fix**:
1. Cap items per run: "Process max 10 items per run."
2. Use smaller models for routine sub-tasks.
3. Increase the interval.
4. Ship scripts for deterministic steps.

---

## Debugging Workflow

When a loop misbehaves, follow this order:

1. **Check the stop condition first** — is it clear, quantifiable, bounded?
2. **Check verification second** — is it strong enough to catch bad work?
3. **Check the goal scope** — is it too broad or too narrow?
4. **Check token usage** — where is the budget actually going?
5. **Add one fix at a time** — don't rewrite the whole loop; change one variable and observe.
