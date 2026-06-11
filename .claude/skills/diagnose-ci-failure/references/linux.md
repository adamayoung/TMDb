# Linux build/test failure (Build and Test (Linux))

The **Build and Test (Linux)** job runs in the `swift:6.1-jammy` container:

```
swift build --build-tests -Xswiftc -warnings-as-errors
swift test  --skip-build  --filter TMDbTests
swift build -c release    -Xswiftc -warnings-as-errors
```

The telltale signature: **it fails on Linux but the macOS `Build and Test` job
passes.** That is almost always a **platform-portability** problem, not a logic
bug — the package targets Linux and Windows alongside the Apple platforms.

## Reading the failure

- `error: '<API>' is unavailable` / `cannot find '<symbol>' in scope` that only
  appears in the Linux job → an Apple-only API reached Linux compilation.
- A test failure present only on Linux → behaviour that differs across Foundation
  implementations (date formatting, URL handling, locale, etc.).

## Common causes & fixes

1. **Apple-only framework used without gating.** This package deliberately gates
   Apple-only services:
   - `naturalLanguageSearch` is behind `#if canImport(NaturalLanguage)`.
   - `TMDbToolbox` / `LanguageModelTools` are behind
     `#if canImport(FoundationModels) && !os(tvOS)` with
     `@available(iOS 26, macOS 26, …)`.
   If new code calls `NaturalLanguage`, `FoundationModels`, `CoreML`, etc.
   without the same `#if canImport(...)` guard (and an `@available` where
   needed), Linux can't compile it.
   - Fix: wrap the Apple-only code path in `#if canImport(<Framework>)` and
     provide a Linux fallback (or exclude the feature on Linux, matching how
     `naturalLanguageSearch` degrades).

2. **Foundation API differences.** Some Foundation APIs behave differently or are
   missing on swift-corelibs-foundation. Recent work in this repo moved off
   `DateFormatter` to `Date.ParseStrategy` / `Date.ISO8601FormatStyle` partly for
   cross-platform consistency — keep to those portable APIs.
   - Fix: use the portable API; if a value differs, assert on the parsed value
     (`try #require(...)`) rather than a locale-dependent string.

3. **`#if os(...)` / availability mismatch** — code compiled into the Linux
   target that references symbols only present on Apple platforms.

## Reproduce locally

Run the Linux toolchain in Docker (matches CI):

```
make build-linux     # swift build in a Swift Docker container
make test-linux       # swift test in a Swift Docker container
```

These surface failures the macOS build never will.

## Output

**Summary:** Build and Test (Linux) — `error` at `file:line`, Linux-only.
**Cause:** Apple-only API/Foundation difference reaching the Linux target.
**Fix:** gate behind `#if canImport(...)` / use a portable API; verify with
`make build-linux` / `make test-linux`.
