---
name: test
description: Run all unit tests
---

# Run tests

Use the Xcode MCP if available, otherwise fall back to Make.

## Xcode MCP (preferred)

1. Run `mcp__xcode__XcodeListWindows` to get the `tabIdentifier` for the TMDb package.
2. Run `mcp__xcode__RunAllTests` with the `tabIdentifier` and the **TMDb** test plan.
3. If tests fail, review the output for failure details. Use `mcp__xcode__GetBuildLog` with `severity: "error"` if build errors caused the failure.

## Fallback

Run `make test` from the project root.
