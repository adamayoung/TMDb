# Lint job failure (SwiftLint / SwiftFormat / the Python gates)

The **Lint** job runs eight check steps, mirroring local `make lint` exactly.
The first two are the style tools; the other six are stdlib-only Python gates
under `Scripts/`, each enforcing something no single-file linter can see:

| Step (ci.yml) | Command | Fails when |
| --- | --- | --- |
| SwiftLint | `swiftlint --strict .` | any lint warning (strict = warnings are errors) |
| SwiftFormat | `swiftformat --lint .` | any file is not already formatted |
| Defaulted-witness check | `python3 Scripts/check-defaulted-witnesses.py` | a protocol convenience would witness its own requirement (site count drifted) |
| Fixture check | `python3 Scripts/check-fixtures.py` | a JSON fixture is invalid/camelCase/orphaned, or a `fromResource:` names a missing file |
| DocC curation check | `python3 Scripts/check-docc-curation.py` | a public method is missing from its DocC curation page |
| Prose call-form check | `python3 Scripts/check-prose-call-forms.py` | a ```swift sample in `README.md` / `**/*.docc/**` calls a service method that does not exist (name or labels) |
| README version check | `python3 Scripts/check-readme-version.py` | `README.md`'s `.package(from:)` lags the newest `CHANGELOG.md` release |
| Run-list builder check | `python3 Scripts/run-script-tests.py` | any suite under `Scripts/tests/` fails — the run-list builder, the `/deliver` selection-prose anti-drift cases, the `deliver-runfile.py` writer, the workflow cache-key/change-gate cases — or fewer tests were collected than the wrapper's exact floor |

A Python-gate failure is **not** a formatting problem — `/format` will not fix
it. Each script prints the defect and the file it found it in; reproduce with
the exact `python3 Scripts/<name>.py` from the table.

Two conditional-runner details worth knowing before you blame the environment:

- The job picks its runner from the paths filter — macOS when the `swift` key
  matched, `ubuntu-latest` otherwise — and gates each step separately. So a
  markdown-only PR legitimately runs *only* the Run-list builder check, and a
  version-only PR runs *only* the README version check; the skipped steps are
  not failures.
- CI pins **SwiftLint `0.63.2`** and **SwiftFormat `0.61.1`** (downloaded as
  exact release binaries). Local versions must match (the local pin lives at
  `~/.local/bin/swiftlint`) or you get spurious failures on unchanged code.

## Reading the failure

- SwiftLint emits `file:line:col: error: <message> (rule_id)`. The `rule_id` in
  parentheses is the lever — look it up in `.swiftlint.yml`.
- SwiftFormat `--lint` lists files it *would* change; it doesn't always say which
  rule. Run `swiftformat --lint --verbose .` locally to see the rules, or just
  format and diff.
- A Python gate names its own failure precisely — read the script's output
  first; each one's header comment documents its failure modes.

## Common causes & fixes

1. **A real style/format violation in changed Swift.**
   - Fix: run `/format` (auto-applies SwiftFormat + SwiftLint autocorrect),
     commit the result, then `/lint` to confirm clean. Most format failures need
     nothing more.
   - For SwiftLint rules that can't autocorrect (e.g. line length, cyclomatic
     complexity, force-unwrap), fix the flagged `file:line` by hand per the
     project's style (line length 120, no force-unwrap/try, guard for early
     exits).

2. **Version drift — `superfluous_disable_command` on *unchanged* code.** A
   rule's behaviour changed between SwiftLint releases, so a
   `// swiftlint:disable` that was needed before is now flagged as superfluous.
   This is almost never a real violation:
   - Check `swiftlint version` against the pinned **0.63.2** (and
     `swiftformat --version` against **0.61.1**). If local is newer, that's the
     cause — match the pin (`~/.local/bin/swiftlint`) rather than editing the
     flagged `// swiftlint:disable`.

3. **A Python gate fired.** The change broke an invariant the gate guards — a
   fixture went stale, a code sample calls a renamed method, a prose anti-drift
   test lost its anchor text. Fix the *defect the script names* (the fixture,
   the sample, the prose), not the script — and if the gate itself is wrong,
   that is a reviewed change to `Scripts/`, never a skip.

## Reproduce locally

- `/lint` — runs `make lint` **directly** (not via a subagent, and it writes no
  log file): both style tools plus all six Python gates, in the same order as
  CI. It is fast and low-output, so the output you need is on stdout.
- A single gate: `python3 Scripts/<name>.py` from the table above.
- `/format` — auto-fixes style, then re-run `/lint`.

## Output

**Summary:** Lint job — the failing step — `rule_id` or script name at `file:line`.
**Cause:** the violation (or version drift, or the gate's named defect) tied to a changed file.
**Fix:** `/format` then `/lint` for style; the script's named fix for a gate; match the pinned tool version for drift.
