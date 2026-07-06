---
name: build-for-testing
description: Compile the TMDb package AND all test targets (without running the tests) to catch test-code compile errors. Use after changing tests or shared code to check everything still builds — delegates to the tooling-runner agent (Haiku) and returns a concise pass/fail + errors-as-file:line summary. Differs from /build, which compiles only the library; to run the tests, use /test.
---

# Build for testing

Spawn the **`tooling-runner`** agent (Agent tool,
`subagent_type: tooling-runner` — its Haiku pin, command recipes, and
reporting contract live in `.claude/agents/tooling-runner.md`) with the
one-line task:

> Run the `build-for-testing` target: compile the TMDb package and all test
> targets.

Relay its report. Do **not** run the build yourself.

If the report is unclear on a failure, read the log path it reports
(`.build/last-build-tests.log`) — or, inside Xcode, refresh diagnostics on
the flagged files — rather than re-running. After fixing the issues,
re-invoke this skill to re-check (a fresh subagent will rebuild).
