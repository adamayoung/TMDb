---
name: integration-test
description: Run the TMDb integration tests against the live TMDb API (the Integration test plan; requires TMDB_API_KEY/USERNAME/PASSWORD). Use before a PR, or after model/fixture changes, to validate against real API responses — delegates to a Haiku subagent and returns counts + failures, distinguishing genuine failures from transient live-API/env issues. For mocked unit tests, use /test.
---

# Run integration tests

Spawn the **`swift-integration-tester`** agent (Agent tool,
`subagent_type: swift-integration-tester`) and relay its report. The agent is
Haiku-pinned and keeps the test output out of your context. Do **not** run the
tests yourself.

If the report is unclear on a failure, read the log path it provides rather than
re-running. After fixing the issues, re-invoke this skill to re-check. To
attribute a failure (live-API/backend drift vs a regression in your change), use
`/diagnose-integration-failure`.
