---
name: integration-test
description: Run the TMDb integration tests against the live TMDb API (the Integration test plan; requires TMDB_API_KEY/USERNAME/PASSWORD). Use before a PR, or after model/fixture changes, to validate against real API responses — delegates to the tooling-runner agent (Haiku) and returns counts + failures, distinguishing genuine failures from transient live-API/env issues. For mocked unit tests, use /test.
---

# Run integration tests

Spawn the **`tooling-runner`** agent (Agent tool,
`subagent_type: tooling-runner` — its Haiku pin, command recipes, and
reporting contract live in `.claude/agents/tooling-runner.md`) with the
one-line task:

> Run the `integration-test` target: the TMDb live-API integration suite.

Relay its report — it distinguishes genuine assertion failures from
transient live-API issues (429/timeout/network) and env/precondition
failures. Do **not** run the tests yourself.

If the report is unclear on a failure, read the log path it reports
(`.build/last-integration-test.log`) rather than re-running. After fixing
the issues, re-invoke this skill to re-check. To attribute a failure
(live-API/backend drift vs a regression in your change), use
`/diagnose-integration-failure`.
