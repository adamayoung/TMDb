---
name: diagnose-ci-failure
description: Diagnose a failing CI workflow run (lint, markdown lint, build, or unit tests) — identify which job failed, the cause, and a concrete fix
---

# Diagnose a CI workflow failure

## Overview

The **CI** workflow (`.github/workflows/ci.yml`) gates every PR and the merge to
`main`. Unlike the live-API integration suite, a CI failure is **almost always
caused by the change under review** — a lint violation, a compile warning/error,
a broken unit test, or a Linux-portability gap. Start from the diff, not from
"maybe it's flaky".

CI fans out into four real jobs (plus a `ci` gate job that only aggregates
results). The diagnosis differs per job, so this skill is a **router**: identify
the failing job, then follow the matching reference file for that job's causes,
fixes, and local-reproduction command.

> **Wrong suite?** If the **Integration** workflow (the live-API suite from
> `integration.yml`) failed — not a CI job — use `/diagnose-integration-failure`
> instead. It leads with the opposite assumption: a scheduled/live-API failure
> is usually backend or data drift, not your change.

## Agent Behaviour Contract

1. **Identify the failing job first** — `Lint`, `Lint Markdown`, `Build and Test`
   (macOS), or `Build and Test (Linux)`. Don't guess the cause before you know
   the job.
2. **Assume the change caused it.** CI gates the PR; read the diff and tie the
   failure to a changed file. Don't open with "transient" or "flaky".
3. **Treat warnings as errors.** Build steps use `-warnings-as-errors` / `--Werror`
   — a deprecation or unused-binding warning is a real failure.
4. **Reproduce locally before declaring a fix** using the matching tool (`/lint`,
   `/build-for-testing`, `/test`, `make lint-markdown`, `make build-linux`).
5. **Output the three sections** (Summary / Cause / Fix) defined below — concise,
   tied to `file:line`.

## Locate the failing run

Use the first that applies:

- A path or run id the caller handed you.
- The current branch's run via the **GitHub MCP** (owner/repo from the `origin`
  remote): `mcp__github__actions_list` method `list_workflow_runs`
  (`resource_id: ci.yml`, `workflow_runs_filter: { branch: <branch> }`), then
  `mcp__github__get_job_logs` (`run_id: <id>`, `failed_only: true`,
  `return_content: true`). (`mcp__github__pull_request_read` method
  `get_check_runs` also shows which job is red.) **Headless / no MCP:**
  `gh run list --workflow CI --branch "$(git branch --show-current)" --limit 1`,
  then `gh run view <id> --log-failed`.
- CI pipes build/test output through **xcsift** in `github-actions` format, so
  the failing lines are GitHub `::error::` annotations carrying `file:line` —
  read those first.

## Quick decision tree

Once you know which job failed:

- **Lint** (`swiftlint --strict` / `swiftformat --lint`)?
  └─ `references/lint.md` — style/format violations + the version-drift gotcha
- **Lint Markdown** (`markdownlint`)?
  └─ `references/markdown.md` — README / DocC markdown rules
- **Build and Test** — the **build** step failed?
  └─ `references/build.md` — compile errors and `--Werror` warnings
- **Build and Test** — the **test** step failed?
  └─ `references/unit-tests.md` — failing `Suite/test`, fixture/model mismatch
- **Build and Test (Linux)** — fails on Linux but passes on macOS?
  └─ `references/linux.md` — Apple-only API gating, Foundation differences

## Triage-first playbook

Symptom → next move:

- **`error: … is unavailable` / `cannot find … in scope`, Linux job only** → `references/linux.md`
- **`warning: … treated as error`** → `references/build.md`
- **`error:` from `swiftc` on macOS build** → `references/build.md`
- **A `Suite/test` recorded a failure / `#expect` failed** → `references/unit-tests.md`
- **Test fails to decode a fixture (`keyNotFound`, `valueNotFound`)** → `references/unit-tests.md`
- **SwiftLint rule violation (`error: … (rule_id)`)** → `references/lint.md`
- **`superfluous_disable_command` on unchanged code** → `references/lint.md` (suspect version drift)
- **SwiftFormat would reformat a file (`--lint` non-zero)** → `references/lint.md`
- **markdownlint `MD0xx` violation** → `references/markdown.md`

## Output format

Produce exactly these three sections (keep it under ~150 words; if the caller
asked for a file, write the markdown there and nothing else, otherwise reply
directly):

**Summary:** which job and step failed, and the specific error (rule /
`file:line` / failing `Suite/test`).

**Cause:** the root cause, tied to a changed file where possible.

**Fix:** the concrete next step from the relevant reference file.

## Reference files

| File | Failing job | Covers |
|------|-------------|--------|
| `references/_index.md` | — | Navigation index by symptom |
| `references/lint.md` | Lint | SwiftLint `--strict`, SwiftFormat `--lint`, pinned versions, drift |
| `references/markdown.md` | Lint Markdown | markdownlint on README + DocC `.md` |
| `references/build.md` | Build and Test (build step) | compile errors, `--Werror` warnings, release build |
| `references/unit-tests.md` | Build and Test (test step) | Swift Testing failures, JSON fixture/model mismatch |
| `references/linux.md` | Build and Test (Linux) | Apple-only API gating, Foundation portability |
