---
name: build-for-testing
description: Compile the TMDb package AND all test targets (without running the tests) to catch test-code compile errors. Use after changing tests or shared code to check everything still builds — delegates to a Haiku subagent and returns a concise pass/fail + errors-as-file:line summary. Differs from /build, which compiles only the library; to run the tests, use /test.
---

# Build for testing

Spawn the **`swift-test-builder`** agent (Agent tool,
`subagent_type: swift-test-builder`) and relay its report. The agent is
Haiku-pinned and keeps the verbose build output out of your context. Do **not**
run the build yourself.

If the report is unclear on a failure, read the log path it provides (or, inside
Xcode, refresh diagnostics on the flagged files) rather than re-running. After
fixing the issues, re-invoke this skill to re-check (a fresh agent will
rebuild).
