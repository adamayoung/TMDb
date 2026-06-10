---
name: integration-test
description: Run integration tests against the live TMDb API
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
- Otherwise run `make integration-test` from the project root.

These require TMDB_API_KEY, TMDB_USERNAME, and TMDB_PASSWORD, which are injected
via the env block in .claude/settings.local.json — no sourcing is needed.

Report back ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and the
  failure message (omit this list if there are none)

Do not paste passing-test output or raw logs.
```

If the subagent reports failures, fix them in your own context, then re-invoke
this skill to re-check (a fresh subagent will re-run the tests).
