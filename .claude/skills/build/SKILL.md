---
name: build
description: Build the project
---

# Build project

Use the `xcode-tools` MCP server when running inside Xcode, otherwise fall back to Make.

## xcode-tools (preferred inside Xcode)

1. Run `mcp__xcode-tools__BuildProject` to build.
2. If the build fails, run `mcp__xcode-tools__GetBuildLog` with `severity: "error"` to see errors.

## Fallback

Run `make build` from the project root.
