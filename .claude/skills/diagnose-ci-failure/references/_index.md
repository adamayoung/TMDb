# CI failure diagnosis — reference index

Each CI job has its own failure signature and reference file. Identify the
failing job (`mcp__github__pull_request_read` method `get_check_runs`, or
`mcp__github__get_job_logs` with `failed_only` — `gh pr checks` /
`gh run view <id> --log-failed` when headless without the MCP), then open the
matching file.

| Failing job (`name:` in ci.yml) | Reference | When to use |
|---|---|---|
| **Lint** | [lint.md](lint.md) | `swiftlint --strict .`, `swiftformat --lint .`, or one of the six `Scripts/*.py` gate steps failed |
| **Lint Markdown** | [markdown.md](markdown.md) | `markdownlint` failed on README, `CLAUDE.md`, a DocC `.md`, `.claude/**`, `knowledge/**` or `.github/*.md` |
| **Build and Test** (build step) | [build.md](build.md) | `swift build … -warnings-as-errors` failed (error or warning) |
| **Build and Test** (test step) | [unit-tests.md](unit-tests.md) | `swift test` failed (filter covers all four unit-test targets) |
| **Build (iOS / tvOS / watchOS / visionOS)** | [build.md](build.md) | the `xcodebuild` simulator matrix failed — platform availability/gating |
| **Build and Test (Linux)** | [linux.md](linux.md) | Fails in the `swift:6.1-jammy` container but passes on macOS |
| **Test (America/Los_Angeles or Pacific/Auckland)** | [unit-tests.md](unit-tests.md) | the TZ matrix failed — a date/calendar assertion depends on the runner's zone |

## By symptom

- `error: … is unavailable` / `cannot find … in scope`, **Linux only** → [linux.md](linux.md)
- `warning: … treated as error` → [build.md](build.md)
- `swiftc` `error:` on the macOS build → [build.md](build.md)
- `#expect`/`#require` failure, recorded `Suite/test` → [unit-tests.md](unit-tests.md)
- `keyNotFound` / `valueNotFound` / `typeMismatch` while decoding a fixture → [unit-tests.md](unit-tests.md)
- SwiftLint `(rule_id)` violation → [lint.md](lint.md)
- `superfluous_disable_command` on **unchanged** code → [lint.md](lint.md) (version drift)
- SwiftFormat `--lint` reports a file would change → [lint.md](lint.md)
- a `python3 Scripts/<name>.py` step failed (fixture / curation / prose / version / run-list) → [lint.md](lint.md)
- fails only in `Build (<platform>)`, macOS build green → [build.md](build.md) (availability gating)
- fails only in `Test (<timezone>)` → [unit-tests.md](unit-tests.md) (local-zone date dependency)
- markdownlint `MD0xx` → [markdown.md](markdown.md)

All paths share the [output format](../SKILL.md#output-format): **Summary / Cause / Fix**.
