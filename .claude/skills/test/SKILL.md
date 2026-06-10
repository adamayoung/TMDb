---
name: test
description: Run all unit tests
---

# Run tests

Delegate the test run to a **Haiku subagent** so the test output stays out of
your context. Use the Agent tool with `subagent_type: general-purpose` and
`model: haiku`, give it the prompt below, then relay its report. Do **not** run
the tests yourself.

Subagent prompt:

```text
Run the TMDb unit tests and report concisely.

- If the xcode-tools MCP is available (inside Xcode), run
  `mcp__xcode-tools__RunAllTests` with the TMDb test plan. If a build error
  caused the failure, call `mcp__xcode-tools__GetBuildLog` with
  `severity: "error"`.
- Otherwise run `mkdir -p .build && make test > .build/last-test.log 2>&1`,
  check the exit status for pass/fail, and summarise from that log file.

Report back ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and the
  assertion message (omit this list if there are none)
- On failure, the full log path `.build/last-test.log` (or, inside Xcode, note
  that the full log is available via `mcp__xcode-tools__GetBuildLog`)

Do not paste passing-test output or raw logs.
```

If the report is unclear on a failure, read the log path it provides rather than
re-running. After fixing the issues, re-invoke this skill to re-check (a fresh
subagent will re-run the tests).
