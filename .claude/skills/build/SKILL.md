---
name: build
description: Build the project
---

# Build project

Delegate the build to a **Haiku subagent** so the (potentially verbose) build
output stays out of your context. Use the Agent tool with
`subagent_type: general-purpose` and `model: haiku`, give it the prompt below,
then relay its report. Do **not** run the build yourself.

Subagent prompt:

```text
Build the TMDb Swift package and report the result concisely.

- If the xcode-tools MCP is available (running inside Xcode), run
  `mcp__xcode-tools__BuildProject`. On failure, call
  `mcp__xcode-tools__GetBuildLog` with `severity: "error"` for details.
- Otherwise run `mkdir -p .build && make build > .build/last-build.log 2>&1`,
  check the exit status for pass/fail, and summarise from that log file.

Report back ONLY:
- Status: succeeded or failed
- Error and warning counts
- Each error/warning as `file:line — message` (omit this list if there are none)
- On failure, the full log path `.build/last-build.log` (or, inside Xcode, note
  that the full log is available via `mcp__xcode-tools__GetBuildLog`)

Do not paste raw build logs or successful-compilation output.
```

If the report is unclear on a failure, read the log path it provides (or call
`mcp__xcode-tools__GetBuildLog`) rather than re-running. After fixing the issues,
re-invoke this skill to re-check (a fresh subagent will rebuild).
