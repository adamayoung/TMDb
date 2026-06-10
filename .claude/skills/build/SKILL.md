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
- Otherwise run `make build` from the project root.

Report back ONLY:
- Status: succeeded or failed
- Error and warning counts
- Each error/warning as `file:line — message` (omit this list if there are none)

Do not paste raw build logs or successful-compilation output.
```

If the subagent reports failures, fix them in your own context, then re-invoke
this skill to re-check (a fresh subagent will rebuild).
