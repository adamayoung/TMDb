---
name: build-for-testing
description: Build the project for testing
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
  `mcp__xcode-tools__BuildProject` with `buildForTesting: true`. On failure,
  call `mcp__xcode-tools__GetBuildLog` with `severity: "error"` for details.
- Otherwise run `make build-tests` from the project root.

Report back ONLY:
- Status: succeeded or failed
- Error and warning counts
- Each error/warning as `file:line — message` (omit this list if there are none)

Do not paste raw build logs or successful-compilation output.
```

If the subagent reports failures, fix them in your own context, then re-invoke
this skill to re-check (a fresh subagent will rebuild).
