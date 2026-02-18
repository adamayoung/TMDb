---
name: build
description: Build the project
---

# Build project

Use the Xcode MCP if available, otherwise fall back to Make.

## Xcode MCP (preferred)

1. Run `mcp__xcode__XcodeListWindows` to get the `tabIdentifier` for the TMDb package.
2. Run `mcp__xcode__BuildProject` with the `tabIdentifier`.
3. If the build fails, run `mcp__xcode__GetBuildLog` with `severity: "error"` to see errors.

## Fallback

Run `make build` from the project root.
