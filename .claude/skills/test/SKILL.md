---
name: test
description: Run all unit tests
---

# Run tests

Use the `xcode-tools` MCP server when running inside Xcode, otherwise fall back to Make.

## xcode-tools (preferred inside Xcode)

1. Run `mcp__xcode-tools__RunAllTests` with the **TMDb** test plan.
2. If tests fail, review the output for failure details. Use `mcp__xcode-tools__GetBuildLog` with `severity: "error"` if build errors caused the failure.

## Fallback

Run `make test` from the project root.
