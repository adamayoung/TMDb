# Code Style

> Topic doc referenced from [`CLAUDE.md`](../../CLAUDE.md). The style rules
> themselves are stated in `CLAUDE.md` — this doc carries the enforcement
> detail: pinned tool versions, the auto-format hooks, and editor-diagnostic
> quirks.

## Enforcement and Pinned Versions

Style is enforced via `swiftlint` and `swiftformat`, both on `PATH`.
**Versions are pinned** — swiftlint `0.63.2` / swiftformat `0.61.1` — and CI
downloads these exact binaries, so keep local versions matched. A
`superfluous_disable_command` error on *unchanged* files is almost always a
version-drift artifact (a rule's behaviour changed between versions), not a
real violation — check `swiftlint version` against the pin before editing the
flagged code.

Line-length details: 120 characters (`.swiftformat --maxwidth 120`; SwiftLint's
`line_length` default, with URLs, comments and interpolated strings exempt per
`.swiftlint.yml`).

## Edit Hooks (PreToolUse Guard + PostToolUse Auto-Formatting)

Three hooks in `.claude/settings.json` fire around every `Edit`/`Write`. A
`PreToolUse` hook **refuses any edit while the checkout is on `main`** (exit 2
with a message) — the enforcement behind `CLAUDE.md`'s *Branching* rule, so the
failure mode is a hard refusal, not a silent bad commit. Two `PostToolUse`
hooks then run after every `Edit`/`Write`, so files are reshaped on disk
**after** you write them:

- **`.swift`** → `swiftlint --fix` then `swiftformat`.
- **`.md` / `.markdown`** → `markdownlint --fix` (auto-fixable rules only).
  `MD013` line-length is **disabled** repo-wide in `.markdownlintrc`, so long
  lines are not a lint failure — wrap prose near 80 columns for readability,
  not to satisfy a gate.

Consequences: the on-disk content can differ from what you wrote (imports
reordered, blank lines collapsed, list markers normalised). **Re-`Read` a file
before a dependent `Edit`** if the edit relies on exact surrounding text, and
don't attribute hook reformatting to your own diff. The hooks can't fix real
compile/lint errors — still run `/lint` and `make ci`.

## SourceKit `<new-diagnostics>` Lag on New Files

After creating a **new** `.swift` file and referencing its symbols elsewhere,
the editor may report `Cannot find 'X' in scope` or a spurious
`No 'async' operations…within 'await'` — **indexing-lag false positives** that
clear on the next build. Trust `make build` / `make build-tests` (they run with
`--Werror`); don't chase them. See
[`knowledge/gotchas.md`](../../knowledge/gotchas.md).
