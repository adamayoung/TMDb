# Gotchas & Lookups

Implementation quirks, tooling traps, and things that needed a lookup to resolve.
Newest at the top. Keep each entry short and dated; link an ADR if a decision came
out of it.

## Tooling

### `EnterWorktree` no longer uses the requested name as the branch name

*2026-07-05.* `EnterWorktree(name: "chore/deliver-retro-before-pr")` created the
worktree directory as `.claude/worktrees/chore+deliver-retro-before-pr/` (the
`/` becomes `+`) but named the **branch** `worktree-chore+deliver-retro-before-pr`
— not the requested name, as earlier deliveries observed. Since the branch is
what the PR and the conventional-prefix rule care about, rename it right after
entering: `git branch -m chore/deliver-retro-before-pr` (safe — nothing is
pushed yet). Check `git branch --show-current` after every `EnterWorktree`
rather than assuming the tool honoured the name.

### GitHub MCP: `/x/<toolset>` paths are exclusive, and `mergeable_state` ≠ `mergeStateStatus`

*2026-06-25.* When wiring the skills to the GitHub MCP ([ADR-0009](decisions/0009-github-mcp-over-gh-cli.md)):

- The hosted endpoint's `/x/<toolset>` paths are **exclusive, not additive**.
  Registering `https://api.githubcopilot.com/mcp/x/actions` mounts *only* the
  `actions` toolset and **drops** the default PR/issue toolset — so
  `pull_request_read`, `create_pull_request`, etc. silently disappear while
  `actions_*` work. Use `…/mcp/x/all` to get the defaults **plus** `actions` under
  one `mcp__github__*` namespace. (`/mcp` alone = defaults only, no `actions`.)
- `pull_request_read` method `get` returns the **REST** `mergeable_state`
  (lowercase `clean`/`blocked`/`behind`/`unstable`/`dirty`/`unknown`/`draft`), **not**
  `gh`'s GraphQL `mergeStateStatus` (uppercase `CLEAN`/`BLOCKED`/…). Any logic ported
  from `gh pr view --json mergeStateStatus` (e.g. `/watch-pr` merge-readiness, the
  BLOCKED→CLEAN lag) must key off the REST field and lowercase values.
- The MCP reply tool (`add_reply_to_pull_request_comment`) needs a numeric REST
  comment id, but `get_review_comments` returns only GraphQL node ids — so posting a
  thread **reply** stays on `gh api graphql` even though resolving threads is on the
  MCP.

### A `Write` of a Markdown/DocC file can leak `</content>`/`</invoke>` into the file tail

*2026-06-24.* When creating a `.md` file with the `Write` tool, trailing
tool-call closing tags (`</content>`, `</invoke>`) can end up appended to the
file content. Neither gate catches it: `make build-docs` renders the unknown
inline text as ordinary prose (no warning), and `markdownlint` doesn't flag it
(`MD013` line-length is off in `.markdownlintrc`, and the tags aren't a lint
violation). Code review caught it in the published article. After a `Write` of a
docs/markdown file, verify the tail — e.g. `tail -3 <file>` or
`grep -nE '</content>|</invoke>' <file>`.

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

### Edits can land in the main checkout instead of the active worktree

*2026-06-23 / updated 2026-06-24.* Two variants of the same trap when working in a
git worktree (e.g. `/deliver`):

- **Fanned-out subagents** — file-writing subagents sometimes wrote to the **main
  checkout** path (`…/TMDb/Sources/…`) instead of the active worktree, despite the
  worktree path being their working directory. Give them **absolute worktree
  paths** for every file.
- **The conductor's own edits** — files `Read` *before* `EnterWorktree` yield
  **main-checkout absolute paths**; continuing to `Edit` those exact paths after
  entering the worktree writes to `main`, not the worktree (they share `.git` but
  have **separate working dirs**). The build/test then runs against the *pristine*
  worktree and returns **baseline** counts (e.g. unchanged total), masking that the
  edits never landed. After `EnterWorktree`, re-`Read`/edit via worktree paths.

Either way: **verify `git status` shows your diff *in the worktree*** (and the main
checkout stayed clean) before trusting a green run. To rescue edits already made on
`main`: `git -C <main> stash` then `git -C <worktree> stash pop` (stash is shared
across worktrees).

### The build/test tooling-runner runs in the main checkout, not the active worktree

*2026-07-24.* During a `/deliver` in a worktree, the `tooling-runner` (Haiku)
subagent behind `/build` / `/build-for-testing` / `/test` / `/integration-test` —
and Agent-tool subagents generally — execute in the **main checkout**, not the
worktree the conductor switched into. So `make test` spawned that way builds
`main`'s pristine sources, **misses the worktree's committed changes**, and
(compounded by the toon `errors[]` quirk below) misreports. **Detect it:** the
run's `.build/last-*.log` lands under the **main checkout** and the worktree's
`.build/` has none. **Work around it for the duration of a worktree delivery:**
run builds/tests **directly via `Bash`** (which does run in the worktree CWD) —
`swift build --build-tests` then `swift test --skip-build --scratch-path .build
--filter "TMDbTests|TMDbTestingTests"` (see the `Makefile` `test` target for the
exact incantation) — instead of delegating to the tooling-runner.

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
- Homebrew silently drifts `swiftformat` (seen: 0.62.1 vs the 0.61.1 pin), which
  then flags **`wrapIfStatementBodies`** on unchanged files *and*, worse, makes
  the PostToolUse format hook reshape edited files away from CI's output.
  Reinstall the pin to `~/.local/bin` (which precedes Homebrew on `PATH`, like
  the swiftlint pin) from the same URL CI uses:
  `curl -fsSL https://github.com/nicklockwood/SwiftFormat/releases/download/0.61.1/swiftformat.zip`,
  unzip, and `install` the binary to `~/.local/bin/swiftformat`.

### `make` build/test targets pipe through xcsift with `pipefail`

- macOS targets pipe compiler/test output through `xcsift`; the Makefile sets
  `set -o pipefail`, so a non-zero exit from `swift build`/`swift test` propagates
  through the pipe. A subagent checking exit status can trust it.
- Install with `brew install xcsift`. Local builds use `xcsift -f toon` (TOON
  format); CI builds use `xcsift -f github-actions` (GitHub annotations).
- Build targets pass `--Werror` (warnings-as-errors) and `2>&1` (compiler
  diagnostics are emitted on stderr). **Linux/Docker targets do not use xcsift.**
- **The `.docc` "unhandled file" warning is a false alarm — trust the exit code,
  not the toon `errors[]` array.** `swift build`/`make build-tests` emit
  `'<pkg>': found 1 file(s) which are unhandled … Sources/TMDb/TMDb.docc` (and the
  `TMDbTesting.docc` twin) because the DocC plugin only loads under
  `SWIFTCI_DOCC=1` (see `Package.swift`), so outside a docs build SwiftPM sees the
  catalogs as unhandled. It is a **package-load warning, not a compile error**, so
  `--Werror` does **not** promote it and the build **exits 0** ("Build complete!").
  But xcsift's `-f toon` output lists it under `errors[…]{file,line,message}` with
  `null,null` coordinates, so a Haiku `/build-for-testing` subagent that keys off
  that array (instead of the exit status) will wrongly report the build as
  **failed**. Re-check the actual exit code before believing it.

  **Beta-toolchain caveat (Swift 6.4 / macOS 27, Xcode 27):** on this toolchain
  `swift build --build-tests -Xswiftc -warnings-as-errors` now **exits 1** on the
  same `.docc` diagnostic, so `make build-tests` / `make test` / `make ci` fail
  locally even though the code is clean (plain `swift build` — no `--build-tests`,
  no `-Werror` — still exits 0). Workaround while on the beta: build tests
  **without** `-Werror` (`swift build --build-tests`) and run them via `swift test
  --skip-build`; to still catch real warnings, build with `-Werror` and require
  `… 2>&1 | grep 'error:' | grep -v unhandled` to be empty. `make build-docs` is
  unaffected — it sets `SWIFTCI_DOCC=1`, so the plugin handles the catalogs.

### The `xcode-tools` MCP only exists inside Xcode

- The `mcp__xcode-tools__*` tools are the native Xcode–Claude Agent integration;
  they are **not available** in a terminal Claude Code session. Fall back to
  `make` there.
- Inside Xcode use the `mcp__xcode-tools__*` tools (`BuildProject`,
  `RunAllTests`/`RunSomeTests`, `XcodeRead`/`XcodeWrite`/`XcodeUpdate`,
  `XcodeGrep`/`XcodeGlob`/`XcodeLS`) — **do not** use `mcp__xcode__*`, a separate,
  redundant server. Select the **TMDb** test plan for unit tests, the
  **Integration** plan for integration tests.
- There is **no `GetBuildLog` tool** — for build-error detail inside Xcode use
  `mcp__xcode-tools__XcodeRefreshCodeIssuesInFile` on the flagged file(s).

### FoundationModels can't build for watchOS under Xcode 27 beta 2 (CoreImage)

- Building the package for a **watchOS** destination
  (`xcodebuild -scheme TMDb -destination 'generic/platform=watchOS Simulator'`)
  fails during module resolution:
  `error: Unable to resolve module dependency: 'CoreImage'` inside the watchOS
  SDK's own `FoundationModels.swiftinterface`. It is an **SDK/toolchain bug**
  (Xcode 27.0 beta 2 / watchOS 27 beta), not a problem in this code — it fires for
  **any** `import FoundationModels` on watchOS, including the existing
  `LanguageModelTools`.
- Consequence: you **cannot build- or availability-verify** watchOS-gated
  FoundationModels code locally yet. The error aborts before type-checking, so it
  even **masks** genuine `@available` violations (a watchOS availability bug and a
  clean build look identical — both fail on CoreImage). Verify such changes by
  reasoning + Apple's documented availability instead, and note the gap.
- Apple **does** document `SystemLanguageModel` / `LanguageModelSession` as
  `watchOS 27.0+ (Beta)`, so `watchOS 27` is the correct availability floor; the
  build failure is transient beta breakage, expected to clear in a later toolchain.
- `make ci` is unaffected — it builds the macOS host only, never watchOS.

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

## Networking

### Bearer-token clients share one credential-free `URLCache` key space

- `TMDbClient(bearerToken:)` (v4 auth) sends the token as an
  `Authorization: Bearer` header, so — unlike `api_key` mode — the credential is
  **not** in the request URL. That's the point (keys stay out of logs/proxies),
  but it means the process-wide default `URLCache` (and the opt-in
  `CacheHTTPClient`, which keys on `request.url.absoluteString`) no longer
  partitions cache entries by credential. Two bearer clients with **different**
  tokens in one process can therefore serve each other cache hits.
- This is **benign today**: the affected v3 `GET` endpoints return app-level
  public data identical across tokens, and user-specific requests carry
  `session_id` in the URL (distinct cache keys, and `CacheHTTPClient` bypasses
  session requests entirely). It would only matter if TMDb started returning
  token-specific data on an otherwise-public GET — worth remembering before
  relying on per-token cache isolation.

### `URLComponents` path round-trip in `TMDbAPIClient.urlFromPath` decodes `%2F`

*2026-06-24.* `TMDbAPIClient.urlFromPath` rebuilds the request URL by reading and
re-assigning `URLComponents.path` (to prefix the API base path). Two non-obvious
Foundation behaviours interact here:

- The `URLComponents.path` **getter percent-decodes** (`%3F` → `?`), and the
  **setter re-encodes** characters invalid in a path component when serialising
  via `.url` (`?` → `%3F`, `#` → `%23`).
- But `/` is a *valid* path separator, so an encoded `%2F` decodes to a literal
  `/` on the getter and is **not** re-encoded — it round-trips into extra path
  segments.

Consequence for the `urlPathSegmentEncoded` hardening
([ADR-0008](decisions/0008-percent-encode-url-path-segments.md)): percent-encoding
a user string before interpolating it into a request path **does** prevent
query/fragment injection end-to-end, but an injected `/` still becomes a real
separator. That residual is path-only — `urlFromPath` force-overrides
`scheme`/`host` to `https://api.themoviedb.org`, so it cannot redirect off-host
(no SSRF). If you ever need to neutralise `/` too, encode after the round-trip
(set `percentEncodedPath`) rather than relying on the segment encoder alone.

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

### `Date(iso8601:)` test helper exists only in the `TMDbTests` target

*2026-06-24.* The `Date(iso8601: "…")` convenience initialiser is defined in
`Tests/TMDbTests/TestUtils/Date+ISO8601.swift`, which belongs to the **`TMDbTests`**
(unit) target only — it is **not** visible to **`TMDbIntegrationTests`**. Using it
in an integration test fails to compile with a misleading *"argument passed to call
that takes no arguments"* (Swift resolves `Date(...)` to the argument-less
`Date()`). The integration target has no date-from-string helper; build dates there
with `Date(timeIntervalSince1970:)` (the existing convention, e.g. the `video.publishedAt`
assertions). This only surfaces when the **integration** target compiles, so a
`make test` that builds all targets — or `/integration-test` — catches it; a
unit-only check may not.
