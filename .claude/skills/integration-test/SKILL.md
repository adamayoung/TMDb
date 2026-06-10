---
name: integration-test
description: Run integration tests against the live TMDb API
---

# Run integration tests

Use the `xcode-tools` MCP server when running inside Xcode, otherwise fall back to Make.

## xcode-tools (preferred inside Xcode)

1. Run `mcp__xcode-tools__RunAllTests` with the **Integration** test plan.
2. If tests fail, review the output for failure details. Use `mcp__xcode-tools__GetBuildLog` with `severity: "error"` if build errors caused the failure.

## Fallback

Run `make integration-test` from the project root.

Either way, this requires the `TMDB_API_KEY`, `TMDB_USERNAME`, and `TMDB_PASSWORD` environment variables. These are injected automatically via the `env` block in `.claude/settings.local.json`, so no sourcing is needed.
