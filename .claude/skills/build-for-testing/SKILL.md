---
name: build-for-testing
description: Compile the TMDb package AND all test targets (without running the tests) to catch test-code compile errors. Use after changing tests or shared code to check everything still builds — delegates to a Haiku subagent and returns a concise pass/fail + errors-as-file:line summary. Differs from /build, which compiles only the library; to run the tests, use /test.
---

# Build for testing

Delegate this to a **Haiku subagent** so the build output stays out of your
context. Use the Agent tool with `subagent_type: general-purpose` and
`model: haiku`, give it the prompt below, then relay its report. Do **not** run
the build yourself.

Subagent prompt:

```text
Build the TMDb Swift package and all test targets, then report concisely.

- If the xcode-tools MCP is available (inside Xcode), run
  `mcp__xcode-tools__BuildProject` so it builds the test targets (pass
  `buildForTesting: true` if the tool supports it). On failure, get per-file
  error detail with `mcp__xcode-tools__XcodeRefreshCodeIssuesInFile` on each
  flagged file.
- Otherwise run
  `mkdir -p .build && make build-tests > .build/last-build-tests.log 2>&1`,
  check the exit status for pass/fail (the Makefile sets `pipefail`), and
  summarise from that log file.

Report back ONLY:
- Status: succeeded or failed
- Error and warning counts
- Each error/warning as `file:line — message` (omit this list if there are none)
- On failure, the full log path `.build/last-build-tests.log` (or, inside Xcode,
  the flagged files so the caller can refresh their diagnostics)

Do not paste raw build logs or successful-compilation output.
```

If the report is unclear on a failure, read the log path it provides (or, inside
Xcode, refresh diagnostics on the flagged files) rather than re-running. After
fixing the issues, re-invoke this skill to re-check (a fresh subagent will
rebuild).
