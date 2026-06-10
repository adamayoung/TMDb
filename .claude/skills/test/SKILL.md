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
- Otherwise run `make test` from the project root.

Report back ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and the
  assertion message (omit this list if there are none)

Do not paste passing-test output or raw logs.
```

If the subagent reports failures, fix them in your own context, then re-invoke
this skill to re-check (a fresh subagent will re-run the tests).
