# Gotchas & Lookups

Implementation quirks, tooling traps, and things that needed a lookup to resolve.
Newest at the top. Keep each entry short and dated; link an ADR if a decision came
out of it.

## Tooling

### swiftlint / swiftformat versions are pinned — drift causes false violations

- CI and local are pinned to **swiftlint 0.63.2 / swiftformat 0.61.1**; CI
  downloads these exact binaries.
- A `superfluous_disable_command` error on **unchanged** files is almost always
  a version-drift artifact (a rule's behaviour changed between versions), **not**
  a real violation. Check `swiftlint version` against the pin before editing
  code — don't "fix" a non-issue.

### `make` build/test targets pipe through xcsift with `pipefail`

- macOS targets pipe compiler/test output through `xcsift`; the Makefile sets
  `set -o pipefail`, so a non-zero exit from `swift build`/`swift test` propagates
  through the pipe. A subagent checking exit status can trust it.

### The `xcode-tools` MCP only exists inside Xcode

- The `mcp__xcode-tools__*` tools are the native Xcode–Claude Agent integration;
  they are **not available** in a terminal Claude Code session. Fall back to
  `make` there.
- There is **no `GetBuildLog` tool** — for build-error detail inside Xcode use
  `mcp__xcode-tools__XcodeRefreshCodeIssuesInFile` on the flagged file(s).

## Testing

### Integration tests need live-API env vars, and can fail transiently

- `make integration-test` requires `TMDB_API_KEY` / `TMDB_USERNAME` /
  `TMDB_PASSWORD` (injected via `.claude/settings.local.json`). A missing var is
  a **precondition** failure, not a test failure.
- They hit the **live** API, so HTTP 429 / timeout / network are possible — a
  truncated log with no assertion failure is likely transient, not a code bug.
  Use `/diagnose-integration-failure` to attribute a failure.

### Fixtures must exercise every decoder branch

- A custom `Decodable` with per-property branches (e.g. `append_to_response`
  optionals) needs a fixture covering **all** branches, plus a "without appended
  data" test asserting the optionals are `nil`. Untested branches hide bugs.
