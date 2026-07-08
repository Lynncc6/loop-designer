# /goal Definition Template

Use this to craft well-formed `/goal` commands.

---

## Goal Anatomy

```
/goal [what to achieve], [stop condition / max tries].
```

## Components

### 1. Achievement (required)
State what "done" looks like, as quantifiably as possible.

Good:
- "get the homepage Lighthouse score to 90 or above"
- "all failing tests in `tests/auth/` pass"
- "every new issue in this batch is triaged and labeled"

Bad:
- "improve performance"
- "fix the tests"
- "handle the issues"

### 2. Stop Condition (required)
Always include a max-try or max-item cap.

Good:
- "stop after 5 tries"
- "max 20 items per run"
- "stop after 3 consecutive attempts with no improvement"

Bad:
- (nothing — infinite retry)
- "when it's done" (circular)

### 3. Verification Hints (optional but recommended)
Tell the agent HOW to check progress.

```
/goal get Lighthouse to 90. After each edit, run the lighthouse skill
to measure. Stop after 5 tries.
```

### 4. Scope Boundaries (optional)
Prevent scope creep.

```
/goal fix the login button. Only modify files in src/components/login/.
Stop after 3 tries.
```

---

## Examples

### Simple (single metric)
```
/goal get the homepage Lighthouse performance score to 90 or above, stop after 5 tries.
```

### Complex (checklist)
```
/goal verify the PR is ready to merge:
1. All CI checks pass (run `ci-check` skill)
2. No unresolved review comments (check via github-mcp)
3. At least 1 approval
4. No merge conflicts
Stop after 3 tries.
```

### Batch (queue processing)
```
/goal process all new bug reports in the #bugs channel.
For each: triage, label, assign owner, and respond.
Max 15 reports per run.
```

### Optimization (convergence)
```
/goal optimize the slow database query in src/db/users.ts.
Run the benchmark after each change.
Stop after 3 iterations with no improvement, or 10 total.
```
