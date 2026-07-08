# Verification Skill Template

Use this to create a skill that teaches an agent how to verify its own work.

---

## Template

```markdown
---
name: verify-[what]
description: Verify [what] end-to-end before declaring it done.
---

# Verifying [What]

Never report [what] as complete based on a successful edit alone.
Verify it the way a human reviewer would.

## Verification Steps

### 1. [Environment Check]
[Make sure the thing can actually run.]
Example: Start the dev server. Confirm it boots without errors.

### 2. [Functional Check]
[Test the core functionality works.]
Example: For a new button: click it, confirm expected state change.

### 3. [Edge Case Check]
[Test boundary conditions.]
Example: Empty input, max-length input, invalid input.

### 4. [Regression Check]
[Make sure nothing else broke.]
Example: Run full test suite. Check no other components are affected.

### 5. [Quality Check]
[Performance, accessibility, etc.]
Example: Run Lighthouse, confirm no regressions.

## If Any Step Fails

Fix the issue and rerun from step 1.
Do not hand back partially verified work.

## Tools Required

- [List any tools, MCPs, or scripts the agent needs]
- Example: browser-mcp, `npm test`, `./scripts/benchmark.sh`
```

---

## Real Example: Frontend Verification

```markdown
---
name: verify-frontend-change
description: Verify any UI change end-to-end before declaring it done.
---

# Verifying Frontend Changes

Never report a UI change as complete based on a successful edit alone.

1. Start the dev server and open the edited page in the browser.

2. Interact with the change directly. For a new control (button, input, toggle):
   click it, confirm the expected state change, and screenshot before/after.

3. Check the browser console: zero new errors or warnings.

4. Use the Chrome Devtools MCP, run a performance trace and audit Core Web Vitals.

5. Run `npm test` — must exit 0.

If any step fails, fix the issue and rerun from step 1.
Do not hand back partially verified work.
```

---

## Real Example: API Verification

```markdown
---
name: verify-api-change
description: Verify any API endpoint change end-to-end.
---

# Verifying API Changes

1. Start the server (or use staging) and confirm it boots.

2. Call the changed endpoint with curl:
   - Happy path: valid request → expected response
   - Error path: invalid request → proper error code + message
   - Auth: unauthenticated → 401, unauthorized → 403

3. Check response schema matches the OpenAPI spec (if one exists).

4. Run the integration test suite: `npm run test:integration`

5. Check that no other endpoints regressed: run `npm test`

If any step fails, fix and rerun from step 1.
```
