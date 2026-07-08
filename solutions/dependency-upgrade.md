# 方案：依赖自动升级

**场景**：npm/pip/cargo 依赖过时了，你想自动升级但不想手动一个个试。

**推荐 Loop 类型**：Proactive
**组合**：`/schedule` + `/goal` + test-verifier + code-review

---

## 为什么选这个组合

- 依赖升级是**周期性任务**（每周/每两周）→ 需要 `/schedule`
- 每个升级有**明确的验证标准**（测试通过）→ 可以用 `/goal`
- 可能需要**批量处理多个包** → 需要 item cap
- 升级有风险（breaking change）→ 需要强验证 + 人工最终确认

## 需要的 Skills

| Skill | 状态 | 用途 |
|-------|------|------|
| `test-verifier` | ✗ 需安装 | 跑测试确认升级没破坏功能 |
| `code-review` | ✅ 内置 | 审查 lockfile 变更是否合理 |
| `release-skills` | ✗ 需安装 | 处理版本号和 changelog（可选） |
| `lint-fixer` | ✗ 需安装 | 如果升级导致 API 变化，自动修复 |

## 一键运行 Prompt

```
/schedule every Monday at 2am:

/goal: upgrade all outdated dependencies that can be safely upgraded.
Max 10 packages per run. Stop after 3 hours total.

Process:

1. Check for outdated dependencies:
   - npm: `npm outdated`
   - pip: `pip list --outdated`
   - cargo: `cargo update --dry-run`

2. Categorize each outdated package:
   - Patch (x.y.Z → x.y.Z+1): safe to auto-upgrade
   - Minor (x.Y.z → x.Y+1.z): probably safe, verify with tests
   - Major (X.y.z → X+1.y.z): risky, flag for human review (skip)

3. For each safe/probably-safe package, in order of risk (patch first):
   a. Upgrade the package: `npm update <pkg>` / `pip install -U <pkg>` / `cargo update -p <pkg>`
   b. Run test-verifier: full test suite must pass
   c. If tests pass:
      - Run code-review on the diff (lockfile + any source changes)
      - If review passes: commit with message "chore: upgrade <pkg> from <old> to <new>"
      - Create PR titled "Upgrade <pkg> to <version>"
      - PR body includes: changelog summary, test results, risk assessment
   d. If tests fail:
      - Try to fix with lint-fixer (if it's a simple API change)
      - If fix works and tests pass → proceed to step c
      - If fix doesn't work → revert, log as "blocked: <pkg> upgrade breaks tests, needs manual"
   e. Move to next package

4. After processing all packages, send a summary:
   - ✅ Upgraded: [<pkg> <old>→<new>, ...]
   - ⚠️ Blocked: [<pkg> <reason>, ...]
   - 🔴 Skipped (major): [<pkg> <old>→<new>, needs human review]
   - PR links for successful upgrades

Do NOT merge any PR automatically. All upgrades require human approval.
```

## Token 预算估算

- 每个包升级：20-50K tokens
- 每次最多 10 个包：200K-500K tokens
- 每周一次 → 约 800K-2M tokens/月

## 风险提示

- ⚠️ **绝对不要自动 merge**——只创建 PR，等人审
- ⚠️ Major 版本升级直接跳过，让人来
- ⚠️ 一次不要升级超过 10 个包——出问题难定位
- ⚠️ 每次只升级一个包然后跑测试——不要批量升级再一起测（无法定位是哪个包搞坏的）
- ⚠️ 在凌晨跑（2am），不占用工作时间的 CI 资源

## 进阶：安全补丁优先

```
/schedule daily at 3am:

1. Check for security advisories:
   - npm: `npm audit`
   - pip: `pip-audit`
   - cargo: `cargo audit`

2. If any security vulnerabilities found:
   - Process ONLY security-relevant upgrades (ignore non-security outdated packages)
   - Same process as above: upgrade → test → PR
   - Mark PR as 🔒 security-critical in title
   - Send notification to #security channel
```
