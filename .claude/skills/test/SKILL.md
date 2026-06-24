---
name: test
description: Run all TMDb unit tests (Swift Testing, the TMDb test plan). Use after code changes and before a PR to verify unit tests pass — delegates the run to a Haiku subagent and returns total/passed/failed counts plus each failure as Suite/test with file:line. For the live-API suite, use /integration-test.
---

# Run tests

Spawn the **`swift-tester`** agent (Agent tool, `subagent_type: swift-tester`)
and relay its report. The agent is Haiku-pinned and keeps the test output out of
your context. Do **not** run the tests yourself.

If the report is unclear on a failure, read the log path it provides rather than
re-running. After fixing the issues, re-invoke this skill to re-check. To re-check
just the previously failing tests faster, the agent can scope the run with
`swift test --filter "SuiteName/testName"` instead of the full suite.
