# CI failure diagnosis — reference index

Each CI job has its own failure signature and reference file. Identify the
failing job (`gh pr checks`, or `gh run view <id> --log-failed`), then open the
matching file.

| Failing job (`name:` in ci.yml) | Reference | When to use |
|---|---|---|
| **Lint** | [lint.md](lint.md) | `swiftlint --strict .` or `swiftformat --lint .` failed |
| **Lint Markdown** | [markdown.md](markdown.md) | `markdownlint` failed on README or a DocC `.md` |
| **Build and Test** (build step) | [build.md](build.md) | `swift build … -warnings-as-errors` failed (error or warning) |
| **Build and Test** (test step) | [unit-tests.md](unit-tests.md) | `swift test --filter TMDbTests` failed |
| **Build and Test (Linux)** | [linux.md](linux.md) | Fails in the `swift:6.1-jammy` container but passes on macOS |

## By symptom

- `error: … is unavailable` / `cannot find … in scope`, **Linux only** → [linux.md](linux.md)
- `warning: … treated as error` → [build.md](build.md)
- `swiftc` `error:` on the macOS build → [build.md](build.md)
- `#expect`/`#require` failure, recorded `Suite/test` → [unit-tests.md](unit-tests.md)
- `keyNotFound` / `valueNotFound` / `typeMismatch` while decoding a fixture → [unit-tests.md](unit-tests.md)
- SwiftLint `(rule_id)` violation → [lint.md](lint.md)
- `superfluous_disable_command` on **unchanged** code → [lint.md](lint.md) (version drift)
- SwiftFormat `--lint` reports a file would change → [lint.md](lint.md)
- markdownlint `MD0xx` → [markdown.md](markdown.md)

All paths share the [output format](../SKILL.md#output-format): **Summary / Cause / Fix**.
