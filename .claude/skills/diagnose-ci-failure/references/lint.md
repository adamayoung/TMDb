# Lint job failure (SwiftLint / SwiftFormat)

The **Lint** job runs on macOS with **pinned** tool versions so CI matches local
`make lint` exactly:

- `swiftlint --strict .` — every warning is an error.
- `swiftformat --lint .` — fails if any file is not already formatted.

CI pins **SwiftLint `0.63.2`** and **SwiftFormat `0.61.1`** (downloaded as exact
release binaries). Local versions must match (the local pin lives at
`~/.local/bin/swiftlint`) or you get spurious failures on unchanged code.

## Reading the failure

- SwiftLint emits `file:line:col: error: <message> (rule_id)`. The `rule_id` in
  parentheses is the lever — look it up in `.swiftlint.yml`.
- SwiftFormat `--lint` lists files it *would* change; it doesn't always say which
  rule. Run `swiftformat --lint --verbose .` locally to see the rules, or just
  format and diff.

## Common causes & fixes

1. **A real style/format violation in changed Swift.**
   - Fix: run `/format` (auto-applies SwiftFormat + SwiftLint autocorrect),
     commit the result, then `/lint` to confirm clean. Most format failures need
     nothing more.
   - For SwiftLint rules that can't autocorrect (e.g. line length, cyclomatic
     complexity, force-unwrap), fix the flagged `file:line` by hand per the
     project's style (line length 100, no force-unwrap/try, guard for early
     exits).

2. **Version drift — `superfluous_disable_command` on *unchanged* code.** A
   rule's behaviour changed between SwiftLint releases, so a
   `// swiftlint:disable` that was needed before is now flagged as superfluous.
   This is almost never a real violation:
   - Check `swiftlint version` against the pinned **0.63.2** (and
     `swiftformat --version` against **0.61.1**). If local is newer, that's the
     cause — match the pin (`~/.local/bin/swiftlint`) rather than editing the
     flagged `// swiftlint:disable`.

## Reproduce locally

- `/lint` — checks SwiftLint + SwiftFormat compliance (Haiku subagent, logs to
  `.build/last-*.log`).
- `/format` — auto-fixes, then re-run `/lint`.

## Output

**Summary:** Lint job — SwiftLint/SwiftFormat — `rule_id` at `file:line`.
**Cause:** the violation (or version drift) tied to a changed file.
**Fix:** `/format` then `/lint`; or match the pinned tool version for drift.
