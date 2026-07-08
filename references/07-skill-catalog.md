# 07 — Skill Catalog: Curated Index by Scenario

Use this to match skills to a user's task. Organized by scenario.
Skills marked [builtin] are available in most Claude Code setups.
Skills marked [community] need to be installed.

---

## Code Review & Quality

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `/code-review` [builtin] | Reviews code for issues, style, bugs | review, PR, code quality, audit |
| `test-verifier` [community] | Runs test suite and reports pass/fail with details | test, CI, pytest, jest, unit test |
| `lint-fixer` [community] | Auto-fixes lint errors (eslint, ruff, etc.) | lint, eslint, ruff, formatting, style |
| `type-checker` [community] | Runs type checking and reports errors | typescript, mypy, type check, tsc |

## Frontend & UI

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `verify-frontend-change` [community] | End-to-end UI verification: server + browser + interaction + screenshot | frontend, UI, component, verify, browser |
| `lighthouse-audit` [community] | Runs Lighthouse and reports performance, accessibility, SEO scores | lighthouse, performance, speed, accessibility, SEO |
| `browser-mcp` [community] | Browser interaction: click, type, screenshot, console check | browser, chrome, playwright, e2e, UI test |
| `design-taste-frontend` [community] | Anti-slop frontend design guidance for landing pages, portfolios | design, UI, landing page, portfolio, redesign |

## Project Management & Collaboration

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `github-mcp` [community] | GitHub operations: PRs, issues, comments, reviews | GitHub, PR, pull request, issue, merge |
| `slack-mcp` [community] | Read/send Slack messages, channels, threads | Slack, message, channel, notification |
| `linear-mcp` [community] | Linear issue management: create, update, triage | Linear, ticket, issue, triage, project |
| `jira-mcp` [community] | Jira issue management | Jira, ticket, sprint, agile |

## Documentation & Knowledge

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `format-markdown` [community] | Formats markdown with frontmatter, headings, structure | markdown, format, docs, documentation |
| `doc-sync` [community] | Syncs documentation between sources (e.g., API → docs) | docs, sync, API docs, auto-generate |
| `summarize` [builtin] | Summarizes content: articles, threads, conversations | summarize, summary, TL;DR, digest |
| `baoyu-translate` [community] | Translates articles between languages with analysis | translate, translation, i18n, multilingual |

## DevOps & Deployment

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `ci-monitor` [community] | Monitors CI status, reports failures, suggests fixes | CI, build, pipeline, GitHub Actions, CircleCI |
| `deploy-checker` [community] | Pre-deployment checks: health, config, migrations | deploy, deployment, release, health check |
| `dependency-upgrade` [community] | Checks and upgrades dependencies with verification | dependency, upgrade, npm, pip, cargo, update |
| `release-skills` [community] | Universal release workflow with version/changelog detection | release, version, changelog, publish |

## Content & Social

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `baoyu-post-to-wechat` [community] | Posts to WeChat Official Account | WeChat, 公众号, article, publish |
| `baoyu-post-to-weibo` [community] | Posts to Weibo | Weibo, 微博, social, post |
| `baoyu-post-to-x` [community] | Posts to X/Twitter | X, Twitter, tweet, social |
| `baoyu-url-to-markdown` [community] | Fetches URLs and converts to markdown | fetch, URL, scrape, article, save |

## Data & Analysis

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `lark-base` [community] | Operates Lark Base (Bitable): search, create tables, field management | Lark, Base, Bitable, 多维表格, database |
| `lark-sheets` [community] | Operates Lark Sheets: read/write cells, export | Lark, Sheets, 电子表格, spreadsheet, Excel |
| `lark-drive` [community] | Manages Lark Drive: upload, download, file management | Lark, Drive, 云空间, file, upload |

## Research & Analysis

| Skill | What it does | Match keywords |
|-------|-------------|----------------|
| `playwright-trace` [community] | Inspect Playwright trace files from CLI | trace, debug, Playwright, inspection |
| `openai-docs` [community] | Up-to-date OpenAI API and product documentation | OpenAI, API, docs, reference |
| `lark-openapi-explorer` [community] | Explores native Lark OpenAPI not wrapped by CLI | Lark, API, OpenAPI, explore |

---

## How to Use This Catalog

When a user describes a task:

1. Extract keywords from their description
2. Search this catalog for matching skills (check all categories)
3. Also scan local installed skills via `scripts/scan-local-skills.sh`
4. Score each match: 3 = direct match, 2 = related, 1 = tangential
5. Recommend top 3-5 skills, noting which are already installed vs need install

**Example**: User says "auto-handle PR reviews"
- Keywords: PR, review, code quality, GitHub
- Matches: `/code-review` [builtin], `github-mcp` [community], `test-verifier` [community], `lint-fixer` [community]
- Recommendation: Use all four, note which are installed
