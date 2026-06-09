---
name: build-for-testing
description: Build the project for testing
---

# Build for testing

Use the `xcode-tools` MCP server when running inside Xcode, otherwise fall back to Make.

## xcode-tools (preferred inside Xcode)

1. Run `mcp__xcode-tools__BuildProject` with `buildForTesting: true` to build the package and all test targets.
2. If the build fails, run `mcp__xcode-tools__GetBuildLog` with `severity: "error"` to see errors.

## Fallback

Run `make build-tests` from the project root.
