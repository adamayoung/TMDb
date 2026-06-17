---
name: test
description: Run all TMDb unit tests (Swift Testing, the TMDb test plan). Use after code changes and before a PR to verify unit tests pass — delegates the run to a Haiku subagent and returns total/passed/failed counts plus each failure as Suite/test with file:line. For the live-API suite, use /integration-test.
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
  caused the failure, get per-file detail with
  `mcp__xcode-tools__XcodeRefreshCodeIssuesInFile` on the flagged files.
- Otherwise run `mkdir -p .build && make test > .build/last-test.log 2>&1`,
  check the exit status for pass/fail (the Makefile sets `pipefail`), and
  summarise from that log file.

Report back ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and the
  assertion message (omit this list if there are none)
- On failure, the full log path `.build/last-test.log` (or, inside Xcode, the
  flagged files so the caller can refresh their diagnostics)

Do not paste passing-test output or raw logs.
```

If the report is unclear on a failure, read the log path it provides rather than
re-running. After fixing the issues, re-invoke this skill to re-check. To re-check
just the previously failing tests faster, the subagent can scope the run with
`swift test --filter "SuiteName/testName"` instead of the full suite.
