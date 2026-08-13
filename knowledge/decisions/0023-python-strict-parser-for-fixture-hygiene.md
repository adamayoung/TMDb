# 23. Enforce fixture hygiene with an independent strict parser, not a Swift test

Date: 2026-08-14

## Status

Accepted (unreleased — tooling only)

## Context

Twenty JSON fixtures under `Tests/TMDbTests/Resources/json/` had accumulated
without any test reading them, one was strictly-invalid JSON, one held Swift
dictionary literal syntax and could never have decoded, and four used camelCase
keys where TMDb sends snake_case. Nothing in the repo could see any of it: the
unit suite only exercises fixtures a test names, and lint only looks at Swift.

The obvious in-repo option — a Swift Testing parameterised test over
`Bundle.module`'s resources — is the one that cannot work for the first defect.
Foundation's JSON parser **accepts trailing commas**; verified empirically that
both `JSONSerialization.jsonObject(with:)` and `JSONDecoder.decode(_:from:)`
accept `{"a": 1,}`. A validator written in Swift would use the very parser whose
tolerance hides the defect, so its green would mean "Foundation didn't mind",
not "this is valid JSON".

## Decision

Enforce it with `Scripts/check-fixtures.py` — stdlib Python, run from **both**
`make lint` (as a `lint-fixtures` prerequisite) and a `Fixture check` step in the
CI `Lint` job.

Python is not incidental: `json.load` is an *independent* strict parser, which is
the entire reason the check can see defect 1. It also follows an existing
precedent — `Scripts/check-defaulted-witnesses.py` is already wired the same way
for a cross-symbol invariant swiftlint cannot express — so this adds no new
toolchain dependency.

Three checks: strict parse; a snake_case key rule (`^[a-z0-9]+[A-Z]`); and
orphan detection in **both** directions (a fixture no test names, and a
`fromResource:` naming no file).

Three properties are load-bearing:

- **The key scan falls back to raw text when a file fails to parse**, so a parse
  failure cannot mask a key defect in the same file. `media-pageable-list.json`
  had both at once.
- **An empty scan exits 1** — zero fixtures, zero Swift files, or zero
  `fromResource:` references. A wrong CWD or a renamed loader must not produce a
  green indistinguishable from a clean tree.
- **No allowlist**, because an always-empty one is untested code and a bypass.

The paths filter reuses `ci.yml`'s existing `swift` key rather than adding a
`fixtures` output. A new output needs a matching `outputs:` declaration, and
without it the gate expression reads an empty string — the step silently never
running while the job reports success. Reusing `swift` also means a fixture-only
PR runs `build-test` and `build-test-linux`, which is correct: fixtures are a
build input of `TMDbTests` via `.process("Resources")`.

## Consequences

- Three defect classes now fail the lint locally and in CI instead of surviving
  indefinitely. Deleting or renaming a fixture without updating its test is a
  lint error rather than a test failure.
- A fixture-only PR now spins the macOS build/test jobs. That is the intended
  cost — the fixture is an input to the tests that must re-run.
- The snake_case rule is a heuristic about TMDb, not a guarantee. It holds across
  all 170 current fixtures. The first genuine camelCase key upstream will fail
  the lint, and the fix is to add an allowlist *with* a staleness check.
- The orphan check's soundness depends on fixture names being literal at every
  call site. That is true today (of 195 sites, the only non-literal ones are
  parameterised tests whose `arguments:` are literal arrays). A future
  dynamically-built name would read as an orphan and need an explicit exemption.
- `make lint` and CI must stay in step by hand; nothing enforces that they agree.

## Alternatives considered

- **A Swift Testing parameterised test over the resource bundle.** Rejected: it
  would use Foundation's tolerant parser, so it could not detect the trailing
  comma that motivated the work. It would also run only in the test job, where
  the point is to fail fast in lint.
- **A one-line `find … -exec python3 -c 'json.load(…)'` in the Makefile** (as
  GitHub issue #422 suggested). Rejected: it catches only defect 1, reports no
  actionable message, and — wired into `make` alone — never reaches CI.
- **A separate `fixtures` paths-filter output in `ci.yml`.** Rejected for the
  false-green and skipped-test-job reasons above.
