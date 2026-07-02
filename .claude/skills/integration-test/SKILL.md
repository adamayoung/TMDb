---
name: integration-test
description: Run the TMDb integration tests against the live TMDb API (the Integration test plan; requires TMDB_API_KEY/USERNAME/PASSWORD). Use before a PR, or after model/fixture changes, to validate against real API responses — delegates to a Haiku subagent and returns counts + failures, distinguishing genuine failures from transient live-API/env issues. For mocked unit tests, use /test.
---

# Run integration tests

Delegate the test run to a **Haiku subagent** so the output stays out of your
context. Use the Agent tool with `subagent_type: general-purpose` and
`model: haiku`, give it the prompt below, then relay its report. Do **not** run
the tests yourself.

Subagent prompt:

```text
Run the TMDb integration tests against the live API and report concisely.

- If the xcode-tools MCP is available (inside Xcode), run
  `mcp__xcode-tools__RunAllTests` with the Integration test plan.
- Otherwise run
  `mkdir -p .build && make integration-test > .build/last-integration-test.log 2>&1`,
  check the exit status for pass/fail, and summarise from that log file.
  **Trust the exit status and `failed_tests` count, not xcsift's `status:`
  field.** Outside a docs build, SwiftPM emits a benign `found N file(s) which
  are unhandled … *.docc` warning that xcsift lists under `errors[]` (with
  `null,null` coordinates) and that can make it print `status: failed` even when
  the run succeeded and `failed_tests: 0`. Treat a 0 exit with `failed_tests: 0`
  as **passed** regardless of that `.docc` entry.

These require TMDB_API_KEY, TMDB_USERNAME, and TMDB_PASSWORD, which are injected
via the env block in .claude/settings.local.json — no sourcing is needed. `make
integration-test` checks these first: if a var is missing, report that as an
**environment/precondition** failure, not a test failure.

Report back ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and the
  failure message (omit this list if there are none)
- Whether the failures look like genuine assertion failures vs a **transient
  live-API issue** (HTTP 429 / timeout / network) or the env/precondition failure
  above — these are not code bugs
- On failure, the full log path `.build/last-integration-test.log`

Do not paste passing-test output or raw logs.
```

If the report is unclear on a failure, read the log path it provides rather than
re-running. After fixing the issues, re-invoke this skill to re-check. To
attribute a failure (live-API/backend drift vs a regression in your change), use
`/diagnose-integration-failure`.
