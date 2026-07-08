# Proactive Loop Template

The most powerful loop type. Composes schedule + goal + skills + workflows.

---

## Anatomy of a Proactive Loop

```
/schedule [when]: [what to check].
/goal: [what "done" means for the batch].
For each item: [how to process, optionally using workflow].
Use [skills] for verification.
[Auto mode if fully autonomous].
```

---

## Template

```
/schedule [interval]: check [source] for [items].

/goal: don't stop until every [item] found this run is
[processed according to criteria]. Max [N] items per run.

For each [item]:
  1. [Step 1: e.g., Triage and categorize]
  2. [Step 2: e.g., If actionable, assign to fixer]
  3. [Step 3: e.g., Use workflow to explore solutions]
  4. [Step 4: e.g., Verify with [skill-name]]
  5. [Step 5: e.g., Create PR / send response / close ticket]

Use [verification-skill] before declaring each item done.
[Use auto mode if this should run without asking permission.]
```

---

## When to Use Proactive Loops

✅ Good candidates:
- Bug report triage (incoming stream, well-defined process)
- PR review automation (external system, recurring)
- Dependency upgrades (periodic, verifiable)
- Issue inbox processing (queue → empty)
- Content moderation (incoming stream, clear rules)

❌ Bad candidates:
- Creative work (no objective "done")
- One-time exploration (overkill)
- Tasks requiring deep domain judgment (can't verify)
- Tasks where wrong action has severe cost (needs human)

---

## Safeguards (always include these)

1. **Item cap**: "Max 15 items per run" — prevents token explosion on busy days
2. **Turn cap per item**: "Stop after 5 tries per item" — prevents one bad item from blocking the batch
3. **No auto-merge**: "Create PR but don't merge without approval" — safety
4. **Notify on failure**: "If an item can't be processed, @mention a human" — graceful degradation
5. **Usage monitoring**: "Check `/usage` after first 3 runs" — cost control
