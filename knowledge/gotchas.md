# Gotchas & Lookups

Implementation quirks, tooling traps, and things that needed a lookup to resolve.
Newest at the top. Keep each entry short and dated; link an ADR if a decision came
out of it.

## Tooling

### DocC symbol links don't resolve across modules — use code spans in a second target

*2026-06-23.* The `TMDbTesting` target depends on `TMDb`, and its doc comments
initially used DocC symbol links to `TMDb`/stdlib types (`` ``GenreService`` ``,
`` ``TMDbError`` ``, `` ``Result`` ``). `make build-docs` failed: those links
resolve against the *current* module's symbol graph, so a cross-module symbol
isn't found (`'GenreService' doesn't exist at '/TMDbTesting'`). Module-qualifying
them (`` ``TMDb/GenreService`` ``) also fails when DocC builds that target's graph
in isolation.

- **Fix:** reference cross-module and stdlib types with **inline code spans**
  (single backticks) — `` `GenreService` ``, `` `TMDbError` ``. Reserve DocC
  `` ``links`` `` for **same-module** symbols (a type's own members).
- **Why it bites CI:** `make build-docs` runs
  `generate-documentation --warnings-as-errors` **without `--target`**, i.e.
  across *all* targets, so a second target's doc-link errors fail the build.

### `make ci` skips the Linux build — CI has a separate `build-test-linux` job

*2026-06-23.* `make ci` does **not** run `make build-linux` (it's lint,
lint-markdown, test, integration-test, build-release, build-docs). Linux/Windows
portability is instead gated by `.github/workflows/ci.yml`'s **`build-test-linux`**
job (container `swift:6.1-jammy`, runs `swift build --build-tests`). So when Docker
isn't available locally to run `make build-linux`, the PR's CI is the authoritative
off-Apple check — don't treat a missing local Linux build as a blocker.

### Workflow file-generation agents can write to the wrong worktree

*2026-06-23.* When fanning out file-writing subagents from inside a git worktree,
some wrote files to the **main checkout** path (`…/TMDb/Sources/…`) instead of the
active worktree, despite the worktree path being given as their working directory.
Give such agents **absolute worktree paths** for every file they create, and
**verify output landed in the worktree** (and the main checkout stayed clean)
before building.

### swiftlint `file_length` / `type_body_length` — split into a `+Feature` extension file

*2026-06-22.* Adding a new `block(for:)` formatter plus its helpers to
`ToolOutputFormatter.swift` (and the matching cases to `ToolOutputFormatterTests.swift`)
tipped both over swiftlint limits: **`file_length` is 400 lines**, and
**`type_body_length` is 250** (excluding comments/whitespace). The fix is the
pattern the codebase already uses for large types — move the new code into a
dedicated `Type+Feature.swift` extension file (e.g. `ToolOutputFormatter+Credits.swift`)
and put new tests in a **separate `@Suite struct`** file.

- **Gotcha when splitting an extension across files:** `private` members are
  visible only within the **same file's** extensions. A helper shared by the new
  file (here `sanitize(_:)`) must be promoted from `private static` to internal
  `static` — `fileprivate` won't reach across files either. `internal` carries no
  `///`-doc requirement (only `public` does), so promoting it is cheap.
- Worth checking the line count before piling onto any already-large
  formatter/aggregator file.
- **When splitting isn't practical** (e.g. a generated `Mock<Name>Service` whose
  length is inherent to a large protocol), disable the rule per-file as the big
  source files already do (`// swiftlint:disable file_length`). But the
  **`blanket_disable_command`** rule treats the two rules differently: a
  never-re-enabled `file_length` disable is allowed, while `type_body_length`
  **must** be paired with a matching `// swiftlint:enable type_body_length` (or
  scoped `:next`/`:this`) — a blanket `type_body_length` disable is itself a
  violation. Disable only the rule a file actually trips, to avoid
  `superfluous_disable_command`.

### SourceKit live diagnostics lag newly-created files — trust the build

*2026-06-18.* After `Write`ing a **new** `.swift` file and referencing its
top-level symbols from another file, the editor's `<new-diagnostics>` repeatedly
reported `Cannot find 'X' in scope` and a spurious `No 'async' operations occur
within 'await' expression` (it couldn't yet see a new `actor`'s cross-actor
members). Every time, `swift build` / `make build-tests` reported **0 errors /
0 warnings** — and those run with `--Werror`, so a real issue would fail them.

- These are **indexing-lag false positives** from SourceKit-LSP; they clear once
  the next build updates the index. There is no config fix — it's inherent.
- **Trust `make build` / `make build-tests` as authoritative.** Do **not**
  investigate a "cannot find in scope" or a spurious `await` warning on a file you
  just created; rebuild instead of chasing it.

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

### Model-decode equality tests: build the expected value directly, not from an over-populated mock

*2026-06-19.* `Network` is `Equatable` over **all six** stored properties
(`id`, `name`, `logoPath`, `originCountry`, `headquarters`, `homepage`), and both
the `Network.mock()` helper and `Network.hbo` default `headquarters` **and**
`homepage` to **non-nil** values. When a decode test compares a decoded value
against an expected one built from a **minimal** JSON fixture entry (only
`id`/`name`/`logo_path`/`origin_country`), building the expected value with the
mock makes `#expect(decoded == expected)` **fail** on the two extra non-nil
fields.

- Construct the expected value **directly** — e.g.
  `Network(id:name:logoPath:originCountry:)`, leaving `headquarters`/`homepage`
  nil — so it matches exactly what the fixture decodes to. `TVSeasonTests` and
  `TVSeriesTests` both do this for their `networks` assertions.
- Generalises to **any** `Equatable` model whose `*+Mocks` helper over-populates
  optional fields: a mock is for convenience construction, not for asserting
  decode equality against a sparse fixture.

## Public API

### `NaturalLanguageSearchService` is not platform-gated — only its `TMDbClient` accessor is

*2026-06-23.* `CLAUDE.md` describes natural-language search as "Apple-platforms
only", which is easy to over-apply. In fact the **protocol** and all its types
(`SearchPlan`, `NaturalLanguageSearchResult`, `NaturalLanguageSearchError`,
`NaturalLanguageSearchAvailability`) only `import Foundation` — **no
`#if canImport(NaturalLanguage)` and no `@available`**. The gating lives solely on
the `TMDbClient.naturalLanguageSearch` *accessor* (and the on-device planner
implementation, e.g. `PersonNameExtracting`, `FoundationModelsSearchPlanGenerator`).
So code that merely conforms to or references the protocol/types (e.g. a mock)
compiles on Linux/Windows and must **not** be wrapped in `#if canImport(...)` —
over-gating would needlessly remove it off-Apple. Gate only the specific symbol
that actually imports `NaturalLanguage`/`FoundationModels`.

### Growing a public protocol additively: extension defaults, and the `--Werror` deprecation trap

*2026-06-18.* Two traps when adding API to a **`public protocol`** (e.g.
`AccountService`) — see [ADR-0005](decisions/0005-authenticated-session-additive-overloads.md):

- **Adding a method as a protocol *requirement* is source-breaking** for every
  external type that conforms to the protocol (they suddenly lack an
  implementation). To add API non-breakingly, declare it as a **protocol-extension
  default**, never a new requirement.
- **Deprecating a method the package calls internally fails the build.** The build
  runs `--Werror`, so a `@available(*, deprecated)` method that the library's own
  code still calls (e.g. `AccountService+Pagination` calling the base account
  methods) turns those internal call sites into deprecation-warning *errors*. To
  deprecate such a method you must migrate every in-`Sources` caller first — or, on
  a public protocol whose requirements can't be removed in a minor release anyway,
  simply don't deprecate (add the new form and document it as preferred).

### Renaming a method's *internal* parameter name is source- and ABI-compatible

*2026-06-18.* Renaming the **second** (internal) name in a parameter —
e.g. `func details(forMovie id: Movie.ID)` → `func details(forMovie movieID: Movie.ID)` —
is **not** a breaking change. Only the **external argument label** (`forMovie:`)
is part of the function's name and the protocol-conformance / override contract;
the internal name is implementation-local.

- Call sites are unchanged (`details(forMovie: 550)` either way).
- DocC symbol links are keyed on argument labels (`details(forMovie:language:)`),
  so they don't break.
- Conforming types need not match the internal name.

Consequence: standardising service parameter names needs **no major version bump
and no deprecation shims** — it only changes Xcode autocomplete placeholders and
the documented signature. (We initially mis-scoped the `<entity>ID` rename as
breaking; it isn't.) See [ADR-0004](decisions/0004-service-parameter-name-convention.md).

## Swift concurrency

### Deterministically testing that cancellation is *forwarded* into an unstructured `Task`

*2026-06-18.* An unstructured `Task {}` does **not** inherit its parent's
cancellation. To forward it, await the child inside
`withTaskCancellationHandler { try await task.value } onCancel: { task.cancel() }`
(see the prefetch iterators, [ADR-0003](decisions/0003-opt-in-pagination-prefetch.md)).

Testing the forward is subtle: a naive test asserting the consumer throws
`CancellationError` passes even if the forward is dropped, because the iterator's
*pre-await* `Task.checkCancellation()` guard also throws. To prove the forward
actually fired:

- Have the awaited child fetcher **signal an `AsyncStream` before blocking** on
  `Task.sleep`, and `await` that signal in the test — so the consumer is provably
  parked **inside** `withTaskCancellationHandler` awaiting `task.value` (past the
  pre-await guard) before you `cancel()`.
- In the child's `catch` (the sleep throws only when the child itself is
  cancelled), record into an `actor` recorder and assert `wasCancelled`. That flag
  is reachable **only** via the forwarded `task.cancel()`, so it can't be set by
  the pre-await guard.
- The sleep duration is a **regression ceiling** (only reached if the forward is
  broken), not a happy-path wait — the happy path cancels in microseconds.

Drive such sequences directly via their `init(pageFetcher:)` with the `actor`
recorder — **never** `MockAPIClient` (it is `@unchecked Sendable` with
unsynchronised state and would data-race under concurrent fetches).

### Public enums are not implicitly `Sendable` — explicit conformance needed for `@Sendable` capture

*2026-06-18.* Adding auto-pagination over a service method captures that method's
non-page arguments into `PagedAsyncSequence`'s `@Sendable (Int) async throws -> …`
page-fetcher closure. The sort enums `FavouriteSort` / `WatchlistSort` /
`RatedSort` conformed only to `CustomStringConvertible`, so they were **not**
`Sendable` — implicit `Sendable` is only inferred for non-`public` types. The
build failed with *"capture of 'sortedBy' with non-Sendable type 'FavouriteSort?'
in a '@Sendable' closure"*.

- **Fix:** add explicit `: Sendable` to the enum (additive, non-breaking — their
  associated values, e.g. `Bool`, were already `Sendable`).
- **Lesson:** before wrapping a service method in any `@Sendable` closure
  (auto-pagination, `Task {}`, etc.), check that every captured **public** type is
  `Sendable`; don't assume a simple value enum already is.

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
