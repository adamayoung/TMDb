# Build failure (Build and Test — build step)

The **Build and Test** job (macOS) has two build steps, both with
**warnings-as-errors**:

```bash
swift build --build-tests -Xswiftc -warnings-as-errors   # build + test targets
swift build -c release      -Xswiftc -warnings-as-errors   # release build
```

Output is piped through `xcsift -f github-actions --Werror`, so diagnostics
surface as GitHub `::error::` annotations with `file:line`.

> A **warning is a failure here.** Code that compiles cleanly in a normal local
> build can still fail CI if it emits any warning. Local `make build` /
> `/build-for-testing` use `--Werror` too, so reproduce with those, not a plain
> `swift build`.

## Reading the failure

- `file:line: error: <message>` — a genuine compile error.
- `file:line: warning: <message>` promoted to an error by `--Werror`. Common
  ones:
  - **Deprecation** — using an API the project (or a newer SDK) deprecated.
  - **Unused** — unused variable, unused result, unreachable code.
  - **Unhandled `Sendable` / concurrency** warnings (strict concurrency is on).
  - **Missing/incorrect availability** annotations.

## Common causes & fixes

1. **Compile error in changed code** — fix the type/signature/import at the
   reported `file:line`.
2. **Warning under `--Werror`** — resolve it properly rather than silencing:
   replace the deprecated call, remove the unused binding, add the missing
   `@available`/`Sendable` conformance. Only suppress with a documented reason if
   the warning is genuinely unavoidable.
3. **Release-only failure** (the `-c release` step) — usually an
   optimisation-sensitive or `#if DEBUG`-gated issue: code that only compiles in
   debug, or a `debug`-only symbol referenced from release paths.

## Reproduce locally

- `/build-for-testing` — builds the package + all test targets with `--Werror`
  (Haiku subagent, logs to `.build/last-build-tests.log`). This is the
  closest match to the failing CI step.
- For the release step specifically: `make build-release`.

## Output

**Summary:** Build and Test — build step — `error`/`warning` at `file:line`.
**Cause:** the compile error or `--Werror` warning, tied to a changed file.
**Fix:** resolve it at `file:line`; reproduce with `/build-for-testing`.

## The `Build (<platform>)` simulator matrix

`Build (iOS)` / `Build (tvOS)` / `Build (watchOS)` / `Build (visionOS)` are one
matrix job that builds the `TMDb-Package` scheme with **`xcodebuild`** against a
generic simulator destination — not SwiftPM — so a green `make build` does not
clear it. A failure here and nowhere else is almost always **platform-specific
API availability**: a symbol that does not exist on that platform, a missing
`@available`/`#if canImport(...)` gate (the `TMDbIntelligence` surfaces are the
usual suspects — `NaturalLanguage` and `FoundationModels` are gated per
platform), or a watchOS/tvOS-only Foundation difference. `--Werror` applies
here too, via `xcsift -f github-actions --Werror`.

Reproduce from Xcode (the **TMDb** scheme against that platform's simulator),
or read the flagged `file:line` — the availability fix is usually evident from
the diagnostic without a local simulator build.

**Summary:** Build (\<platform\>) — `error` at `file:line`.
**Cause:** platform-specific availability/gating, tied to a changed file.
**Fix:** add or correct the `@available` / `#if canImport` gate at `file:line`.
