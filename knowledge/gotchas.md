# Gotchas & Lookups

Implementation quirks, tooling traps, and things that needed a lookup to resolve.
Within each section, **dated entries are newest-first** and undated evergreen
conventions sit at the bottom. Keep each entry short, and **date every entry
that records an observation** (an undated entry can never be aged out); link an
ADR if a decision came out of it. Cite the **PR** that did the work, not the
issue — see `README.md`.

## False green — the recurring failure family

A signal only proves what it measures. The costliest recurring mistake in
this project is accepting a passing signal as evidence of a claim it does not
measure. Before letting any green close a loop — "implementation done",
"ready to merge", "the API supports this", "the guarantee holds" — ask:
**would this signal look any different if the thing I'm claiming were
broken?** If not, it is not evidence; find the check that discriminates.

Instances, each with its countermeasure:

- **Green build of the wrong tree** — edits landed in the main checkout while
  the pristine worktree built green with baseline test counts (#361); the
  tooling-runner built the main checkout instead of the worktree (#397, fixed
  in #399). *Check: `git status` shows your diff in the tree that built.*
- **Pipe summary vs process exit** — `swift build` can exit 1 while `xcsift`
  exits 0, and toon `errors[]` can list a benign diagnostic on a passing
  build. *Check: the `pipefail` exit status is the verdict (see Tooling).*
- **Debug-green vs release-broken** — a `@testable import` in a non-test
  target passed debug, `--build-tests`, 2868 unit and 291 integration tests;
  only `swift build -c release` failed (#398). *Check: run the release build
  before declaring done — now a `/deliver` Phase 3 checkpoint (#400).*
- **"No failures" while a required check was still running** — a stale
  "ready" call read absence-of-red as green (#361). *Check: every required
  check is `COMPLETED` + `SUCCESS` on the current tip.*
- **HTTP 200 on an ignored query parameter** — TMDb returns 200 for bogus
  discover parameters (see `tmdb-api-notes.md`). *Check: assert the response
  content changed, never just the status.*
- **A test asserting a guarantee it cannot observe** — the memoising-actor
  gate test passed while unable to see joining callers: green by coincidence,
  flaky by construction (#401). *Check: make the assertion fail once (break
  the code or the input) before trusting its green.*
- **A new check wired only into `make`** — a lint gate added to the `lint`
  target never ran in CI, because the `Lint` job invokes `swiftlint` and
  `swiftformat` as inline steps and no workflow calls `make` at all. Green CI
  meant "nobody checked" (2026-08-07). *Check: grep `.github/workflows/` for
  the tool you just wired — see Tooling.*
- **A checker that passes on an empty scan** — pointed at a typo'd path, a
  static analyser found zero sites, satisfied "no violations", and exited 0.
  Its green was byte-identical to a clean tree's (2026-08-07). *Check: compare
  against an expected **set**, not a threshold, so an empty result fails; and
  run the analyser against a deliberately wrong input before trusting it.*
- **N mechanical edits reported, wrong symbols edited** — a sweep script did a
  first-occurrence `str.replace` per file, so it stripped the default argument
  from `favouriteMovies` rather than `lists`, and still reported exactly the 36
  edits expected (2026-08-07). *Check: a matching edit **count** is not
  evidence; assert each edit landed on the symbol it was aimed at.*

The same discipline applies to this knowledge base: an entry that reads
confidently is not thereby true. `/review-knowledge` audits it against the tree.

When an instance's countermeasure becomes tooling-enforced, its bullet may be
retired; the family heading stays.

## Tooling

### No workflow runs `make` — a check added to a `make` target does not reach CI

*2026-08-07.* The `Makefile` and CI are **parallel implementations**, not one
delegating to the other. `.github/workflows/ci.yml`'s `Lint` job downloads
pinned binaries and runs `swiftlint --strict .` / `swiftformat --lint .` as two
inline steps; `build-test` runs `swift build` / `swift test` directly. Grep
confirms it: **`make` appears nowhere in `.github/workflows/`** except inside
comments.

So adding a step to the `lint` target (or to `ci`) gates only a local
`make ci` — an outside contributor, a GitHub-web edit, or a headless
`/fix-integration-failures` run (which verifies with the targeted suite, not
`make ci`) sails past it with a fully green CI. `Scripts/check-defaulted-witnesses.py`
shipped this way for one review round before it was caught.

**Wire a new check in both places**, and add its inputs to the `changes`
paths-filter *and* `on.push.paths` — otherwise a PR touching only that script
skips the whole job that runs it.

### Removing a force-unwrap orphans its `swiftlint:disable` — `--strict` then fails

*2026-07-28 (#404).* Making a property optional let two
`URL(string: …)!` force-unwraps in `Company+Mocks.swift` become plain optionals.
Each was preceded by `// swiftlint:disable:next force_unwrapping`; with the `!`
gone those comments suppress nothing, and `make ci` runs `swiftlint --strict`,
under which **`superfluous_disable_command` is an error**. The build and the
whole test suite stay green — this fails only at the lint gate.

**When you delete a `!` or a `try!`, delete its `disable` comment in the same
edit**, and grep the file for orphans (`grep -n "disable:next" <file>`). Same
applies in reverse to `file_length` / `type_body_length` disables after a split.

### Docs builds need their own scratch path — sharing one invalidates the other

*2026-07-27 (#401, fixed in #402).* `Package.swift` branches on `SWIFTCI_DOCC`:
the `=1` path **adds** the swift-docc-plugin dependency, the `else` path **sets
`exclude`** on the four `.docc`-bearing targets. Those are two different
dependency graphs *and* two different per-target source lists. Every `make`
target used to share one `SCRATCH_PATH`.

Verify the divergence in seconds — no build needed:

```bash
swift package resolve                 # no Package.resolved at all: zero dependencies
SWIFTCI_DOCC=1 swift package resolve  # two pins: swift-docc-plugin, swift-docc-symbolkit
```

Consequences:

- **Interleaving `make build-docs` with `make test` / `build-release` rebuilds
  far more than you expect**, because each flip changes the manifest under the
  shared build plan. `make ci` does this flip once by design.
- **It is actively destructive under concurrency.** If anything else is building
  into `.build` — notably fanned-out review subagents, which cannot see each
  other — a docs run re-resolves the manifest out from under an in-flight build.
  They then contend on `.build/.lock` and repeatedly redo invalidated work. The
  symptom is many `zsh` pipelines (each target is `swift … | xcsift`) pinned at
  100% for far longer than the work justifies. Observed: a 5-step gate reporting
  **69 minutes** against a true cost of a few.
- **Fixed in #402:** the three `SWIFTCI_DOCC` targets now use their own
  `DOCS_SCRATCH_PATH` (`.build/docs`), so a docs build never touches the
  directory the other targets use — after `make build-docs`, `.build/` contains
  only `docs`. **Keep it that way**: pointing docs back at `SCRATCH_PATH`, or
  adding a fourth docs target that forgets the variable, reintroduces all of the
  above.
- The same reasoning applies to any future manifest-conditional build mode: a
  build whose *manifest* differs needs its own scratch directory, not just its
  own flags.

Related and often mistaken for this: the live integration suite is *deliberately*
serialised (40 suites carry `.integrationGate`, a global semaphore), so 300 live
tests run one at a time. That is long wall-clock by design, not contention —
don't "fix" it.

### A new target with a `.docc` catalog must be added to `Package.swift`'s exclude list

*2026-07-24 (#396; re-hit in #398).* The DocC plugin loads only under
`SWIFTCI_DOCC=1` (`make build-docs`). Outside a docs build nothing claims the
`.docc` catalogs, so `Package.swift`'s `else` branch `exclude`s each one —
**enumerated per target** (four today). Since Swift 6.4 / Xcode 27,
`-Xswiftc -warnings-as-errors` promotes the resulting "unhandled files"
package-load warning to an error, so a target whose catalog is missing from
that list fails **every** `make` build/test/release target — in CI (which pins
`Xcode_27.0`) and locally on any Xcode 27 toolchain — with:

```text
error: 'TMDb': found 1 file(s) which are unhandled; explicitly declare them
as resources or exclude from the target
```

- **Adding a target with a DocC catalog ⇒ extend the `exclude` block in the
  same change.** #398 added two catalogs, rebased cleanly onto #396, and
  compiled green under plain `swift build` — only `make ci` caught the
  omission, because the error needs `-warnings-as-errors`.
- `make build-docs` is unaffected either way — it sets `SWIFTCI_DOCC=1`, so
  the plugin handles the catalogs.

### A non-test target can never `@testable import` — it breaks `swift build -c release` only

*2026-07-24 (#398).* Sharing test fixtures between two test targets needs a
**regular** `.target` (SwiftPM does not let a `.testTarget` depend on another
`.testTarget`). But a regular target is in the **default build graph**, and
`@testable import TMDb` requires `TMDb` to be compiled with `-enable-testing`,
which only happens in **debug**. So `Tests/TMDbTestFixtures` compiled fine for
`swift build`, `swift build --build-tests`, and the whole test suite, and failed
only under `swift build -c release`:

```text
error: module 'TMDb' was not compiled for testing
```

That is `make build-release` — i.e. `make ci` and both CI *Build for Release*
jobs. **Debug-green proves nothing here; run the release build.**

- **Whole-module-optimization hides the culprit.** Release builds use WMO, so
  *one* offending file fails the *whole module* and the error is reported
  against whichever file the compiler reached first — in our case a file that
  had already been converted to a plain `import`. Don't trust the reported
  filename; grep the target for `@testable`.
- **Fix:** make the shared target build on public + `package` API only. Promote
  the few internals it genuinely needs (here `APIClient`, `APIRequest`,
  `APIRequestMethod`, and `DateFormatter.theMovieDatabase`) to `package`, which
  is package-wide but **not** visible to consumers, so the public API is
  unchanged. Converting all 27 `@testable` imports surfaced that exactly *one*
  internal symbol was actually needed.
- **`package` on a protocol's requirements is an error** — "protocol
  requirements implicitly have the same access as the protocol itself". Put
  `package` on the `protocol` declaration only.
- **What must stay behind:** a fixture for an *internal* type can't live in the
  shared target at all (an extension can't be more visible than its type), so it
  belongs in whichever test target `@testable`-imports it. Promoting such a type
  cascades into member-level access (memberwise inits, nested types) — usually
  not worth it.

### `git ls-tree` doesn't support `:!exclude` — and fails into an empty hash

*2026-07-29.* Building a content stamp over "everything except `knowledge/`",
the obvious form is a silent trap:

```bash
git ls-tree -r HEAD -- . ':!knowledge'   # fatal: pathspec magic not supported
```

`ls-tree` (unlike `git diff` / `git log` / `git ls-files`) has **no exclude
pathspec magic**. Piped into `git hash-object --stdin`, the failure feeds it
**empty stdin**, which hashes to git's empty blob
`e69de29bb2d1d6434b8b29ae775ad8c2e48c5391` — *every time*. So two "stamps"
compare **equal** and the check passes while measuring nothing. A textbook
member of the **False green** family at the top of this file: the signal looks
identical whether or not the thing being checked is broken.

Use a line filter on the output instead — `ls-tree -r` emits
`<mode> <type> <object>\t<path>`, so the tab keeps the path field unambiguous:

```bash
git ls-tree -r HEAD | grep -v $'\tknowledge/' | git hash-object --stdin
```

**Always sanity-check a hash against the empty blob** before trusting a
pipeline that computes one. Verified while designing the `/deliver` resume
stamp, which needs a hash that survives `/pr`'s rebase (so a commit sha is
unusable) and ignores the pipeline's own `knowledge/` bookkeeping commits.

### The build/test tooling-runner runs in the main checkout, not the active worktree

*2026-07-24.* During a `/deliver` in a worktree, the `tooling-runner` (Haiku)
subagent behind `/build` / `/build-for-testing` / `/test` / `/integration-test` —
and Agent-tool subagents generally — execute in the **main checkout**, not the
worktree the conductor switched into. So `make test` spawned that way builds
`main`'s pristine sources, **misses the worktree's committed changes**, and
(compounded by the toon `errors[]` quirk below) misreports. **Detect it:** the
run's `.build/last-*.log` lands under the **main checkout** and the worktree's
`.build/` has none — or, when the worktree adds a *new* suite, the run reports
**"no matching test cases found"** for a `--filter` naming suites that plainly
exist (observed 2026-07-24, #397).

**Fixed 2026-07-24** — the four skills now pass `Package directory: <absolute
CWD>` in the task, and `tooling-runner` refuses to run without it, verifies
`Package.swift` is there, uses `make -C "<dir>"` with absolute log paths, and
echoes the directory it used. So the failure mode is now an explicit error
rather than a plausible-looking wrong answer. **If you see a runner report
without a `Directory:` line, it predates the fix — treat its result as
untrusted** and re-run. **Prefer `make -C "<dir>" test`** as the fallback: it
runs in the worktree CWD *and* takes the filter from `Makefile`'s `TEST_TARGET`,
so it cannot drift.

Going direct via `Bash` means hand-writing the filter, and **all four**
unit-test targets must be named:

```bash
swift build --build-tests --scratch-path .build
swift test --skip-build --scratch-path .build \
  --filter "TMDbTests|TMDbTestingTests|TMDbIntelligenceTests|TMDbIntelligenceTestingTests"
```

A hand-copied two-target filter runs half the suite and reports green — at the
exact moment this entry says to distrust the runner, i.e. when a narrower green
is least likely to be questioned (**False green**, top of this file). Check it
against `Makefile:2` before trusting it.

**Extended 2026-07-29** — the `Directory:` / `Status:` lines are now a
**contract**, and refusals report in the same shape (`Status: refused —
<reason>`). That closes a hole: a refusal is a *caller bug* and carried no
`Status:` line, so a naive "missing lines ⇒ fall back to `make`" rule would
have converted this loud detector into a silent success path — the exact
failure it was built to prevent. Callers now branch on shape: `refused` →
hard error, never a fallback; `passed`/`failed` → a real result; **absent or
malformed** → the subagent died, the run is *void* (not failed), re-invoke once
then fall back with disclosure. The four skills carry the table.

### Worktrees: the lock outlives the session, and `.claude/worktrees/` isn't there

*2026-07-29.* Four facts that together broke `/deliver`'s GC sweep, all verified
first-hand while rewriting it:

1. **`.claude/worktrees/` is a CWD-relative path that does not exist *inside* a
   worktree.** Any sweep doing `ls .claude/worktrees/` from a worktree
   enumerates **nothing** and reports success — a garbage collector that is
   clean because it looked in the wrong place (**False green**, top of this
   file). Enumerate with **`git worktree list --porcelain`**.
2. **That listing reports the *main checkout* first**, and every worktree of the
   repo — including any you made by hand, anywhere on disk. Filter to
   `<main-root>/.claude/worktrees/` before acting, or a sweep will happily
   remove a workspace `/deliver` never created.
3. **`EnterWorktree` *locks* its worktree**, and the lock **outlives the session
   that made it**:

   ```text
   .git/worktrees/<name>/locked
   claude session <branch> (pid 85995 start Wed Jul 29 19:28:23 2026)
   ```

   `git worktree remove --force` **refuses on a locked worktree**, so the
   dead-session worktrees a sweep most wants to reclaim are exactly the ones it
   cannot — while happily reporting them reclaimed. **`git worktree unlock
   <path>` first**, and `test -d` afterwards before counting a reclaim.
   The lock's PID is also the only *fact* about liveness: test it (`kill -0`)
   rather than guessing from a file's age.
4. **`git rev-parse @{u}` errors** (rather than returning false) on a
   never-pushed branch, so an "is it pushed?" proof must treat that as
   *unproven*, not as *failed*.

Related: `ExitWorktree` only removes worktrees **it** created this session — one
entered via `EnterWorktree(path:)` must be removed with `git worktree remove`
by hand, or the call silently no-ops while you report a reclaim
([ADR-0015](decisions/0015-durable-deliver-run-state.md)).

### In a worktree session, Bash refuses commands it can't prove stay inside it

*2026-08-12 (#432).* A worktree-isolated session guards `Bash`, rejecting
anything it cannot statically verify targets the worktree:
*"this command is too complex to verify that it stays inside the worktree; break
it into plain, separate commands."* It fires on shape, not on actual destination,
so it also blocks commands that were never leaving. Seen refusing:

- `jq … > "$tmp" && mv "$tmp" "$file"` and `curl -o <path>` where the path was
  built from a variable — including writes to `.git/deliver/` (the durable
  `/deliver` run file), which lives in the **common** git dir and is therefore
  outside the worktree path by design.
- Multi-stage pipelines with `$(…)` substitution, `for`/`while` loops over
  `curl`, and `cd "$SOMEWHERE"` followed by a redirect.

Workarounds, in order of preference: keep each command **single-purpose with
fully literal paths** (`sed -i '' 's/…/…/' /abs/literal/path` succeeded where the
`jq`+`mv` equivalent was refused); write scratch output **inside** the worktree
under `.build/` (gitignored); or delegate the work to a subagent, which is not
subject to the caller's guard. `Edit`/`Write` on a path outside the worktree are
refused too, with a pointer to the worktree copy — which is wrong for
`.git/`-relative state, so reach for `sed` there.

### The `Workflow` tool resolves a repo-relative `scriptPath`

*2026-07-29.* The three embedded-script skills describe `scriptPath` only as
"the file path the `Workflow` tool returns", which reads as tool-managed. It
also accepts a **repo-relative path** — `Workflow({ scriptPath:
'.claude/workflows/deliver-panel.js' })` resolves and executes. That is what
makes a committed, version-controlled workflow script viable rather than
re-authored prose.

Two testing notes: a script's **argument-validation `throw`s run before any
agent spawns**, so guard rails can be exercised for free (the run fails with
`agent_count: 0`); and such a script **cannot be run standalone** with `node` —
it uses harness globals (`agent`, `parallel`, `phase`, `log`, `args`) and a
top-level `return`. Test it by extracting the body and supplying stubs.

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

> **Update (2026-07-24, #398):** this is **conditional on how the docs
> are built**. Once the build passes `--enable-experimental-combined-documentation`
> with every doc-bearing target listed (as `documentation.yml` and
> `make generate-docs` now do), the module-qualified form **does** resolve:
> `` ``TMDb/TMDbClient/languageModelTools`` `` builds clean under
> `--warnings-as-errors` and produces a real link. Prefer it over a code span
> when you want navigation — a code span silently loses the link. The
> **unqualified** form (`` ``TMDbClient`` `` from another module) still fails
> either way, and stdlib types still want code spans.

### `make ci` skips the Linux build — CI has a separate `build-test-linux` job

*2026-06-23.* `make ci` does **not** run `make build-linux` (it's lint,
lint-markdown, test, integration-test, build-release, build-docs). Linux
portability is instead gated by `.github/workflows/ci.yml`'s **`build-test-linux`**
job (container `swift:6.1-jammy`), which runs the full trio — `swift build
--build-tests`, `swift test` over all four unit-test targets, and
`swift build -c release`. So when Docker isn't available locally to run
`make build-linux`, the PR's CI is the authoritative off-Apple check — don't
treat a missing local Linux build as a blocker.

**One carve-out, added 2026-08-12 (#433).** For a **hand-rolled concurrency
primitive** — a continuation wrapper, a lock, an `@unchecked Sendable` box —
run `make test-linux` *before* opening the PR if Docker is up. That class is
invisible to every Apple-side gate and to a diff-reading reviewer: an
uninitialised read in `ResumeOnce` was `nil` garbage on Darwin and passed 3144
tests, `make ci`, two review passes, a security review and an independent
grader, then segfaulted on Linux and wedged the runner so hard it ignored both
GitHub's concurrency cancel and `gh run cancel`. Everything else (`#if os(…)`,
ordinary portability) fails loudly at compile time and can safely wait for CI.
Docker down → say so and flag the PR Linux-unverified, don't skip silently.

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

### `make` build/test targets pipe through xcsift — the exit status is the verdict, not the summary

- macOS targets pipe compiler/test output through `xcsift`; the Makefile sets
  `set -o pipefail`, so a non-zero exit from `swift build`/`swift test`
  propagates through the pipe. **Trust the pipeline's exit status over any
  rendering of its output** — the two can disagree in both directions:
  `xcsift` itself exits 0 on input whose producer failed (check `pipestatus`
  when debugging the pipe itself), and its `-f toon` `errors[…]` array can
  carry a benign package-load diagnostic with `null,null` coordinates while
  the build exited 0 — a subagent keying off that array once reported a
  passing build as failed.
- Install with `brew install xcsift`. Local builds use `xcsift -f toon` (TOON
  format); CI uses `xcsift -f github-actions` (GitHub annotations).
- Build targets pass `--Werror` (warnings-as-errors) and `2>&1` (compiler
  diagnostics are emitted on stderr). **Linux/Docker targets do not use
  xcsift.**

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

### FoundationModels can't build for watchOS under Xcode 27 beta (CoreImage)

*Undated original; still open as of 2026-07-28 on Xcode 27.0 build `27A5228h` (a
seed build). **Transient by nature — re-probe and delete once a GM toolchain
ships**; a watchOS build is the only way to confirm, so it was not re-run during
the 2026-07-28 audit.*

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

### Extraneous `CodingKeys` cases break synthesized `Encodable`

*2026-08-12 (#418).* Adding a `CodingKeys` case with **no matching stored
property** — the normal way to decode a second key spelling, e.g. `name` alongside
`title` — stops `Encodable` synthesising, because nothing can produce a value for
that key. The compiler error names the conformance, not the extra case, so it
reads like an unrelated problem.

Every model here that decodes two key spellings already hand-writes `encode(to:)`
for exactly this reason — `CollectionListItem`, and `V4List` (a `comments` key
with no `comments` property). If you extend a `CodingKeys`, budget for the encoder
too, and decide deliberately which spelling it emits.

The reverse is fine, and is how you *skip* a property: a stored property absent
from `CodingKeys` is simply not encoded.

### A `package` symbol cannot be referenced by a DocC link

*2026-08-12 (#418).* ` ``droppedItemCount`` ` in a doc comment fails
`make build-docs` with `error: 'droppedItemCount' doesn't exist at '/TMDb/…'`
when the symbol is `package` or `internal` — DocC resolves public API only, and
the build is warnings-as-errors. Describe it in prose or use a code span. Same
family as the cross-module link trap.

### Check how a page is *built* before reasoning about its decode tolerance

*2026-08-12 (#418).* Three `PageableListResult` specialisations are never decoded
at all — `<MediaListItem>`, `<V4ListItem>` and `<ChangedID>` are assembled in
Swift from an already-decoded model (`TMDbListService`, `TMDbV4ListService`,
`ChangesService+Pagination`). The page type's decode behaviour, tolerant or
strict, simply does not apply to them, and a drop count reaches the caller only if
the hand-off passes it along explicitly.

This produced a wrong premise that survived into a plan and a commit message:
"`lists.items(forList:)` silently drops TV rows". It threw, exactly like
`lists.details(forList:)`, because both decode the same `MediaList`. Grepping for
the *request* type (`DecodableAPIRequest<…>`) answers it in one step.

### Carry a decode marker inside a `DecodingError`, not as a bare custom error

*2026-08-12 (#418).* To let a container skip one specific decode failure and stay
loud for the rest, you need to mark that failure. Throwing a custom `Error` from
`init(from:)` works, but leaks: every model's `init(from:)` is **public**, so a
consumer decoding their own cached JSON gets a type they cannot name, and
`catch let error as DecodingError` silently stops matching.

Throw `DecodingError.dataCorrupted` with the marker as its `underlyingError`, and
match on that. The public contract is preserved by construction, and it removes
any question about whether a custom error survives a given platform's
`JSONDecoder` — a `DecodingError` is that decoder's own currency, which matters
because Linux uses swift-corelibs-foundation's separate implementation.

## Testing

### A fixture the author invented tests the author's belief, not the API

*2026-08-12 (#418).* Two bugs in one delivery were hidden by hand-written
fixtures that could not fail:

- `tv-series-details-append-response.json` gave the appended `lists` section
  TV-series-shaped rows with `"media_type": "tv"`. The real endpoint returns list
  *summaries* with no `media_type` at all, so the property was typed wrong and had
  always decoded to an empty array. The test asserted only `!results.isEmpty`.
- `MediaListItemTests` had a "TV show" case whose JSON carried `title` and
  `release_date` — keys TMDb never sends for a series. It passed while
  `lists.details(forList:)` failed on every real mixed list.

Both shapes are the same: a fixture invented from the model, then asserted
loosely enough that the invention is never challenged. Source a fixture from a
real response, and assert its *contents*, not that a collection is non-empty —
an emptiness check passes for a page that decoded nothing.

Related: an orphan fixture is worse still. `media-list.json` had **no consumer at
all**; `git grep` for a fixture's name before trusting that it covers anything.

### An empty-string-guard fixture must come from a real record — `null` passes either way

*2026-08-12 (#432).* `decodeNonEmptyDateIfPresent` and plain
`decodeIfPresent(Date.self)` behave **identically** on JSON `null` and on an
absent key. Only `""` tells them apart. So a hand-written "blank date" fixture
that uses `null` instead of `""` passes with *and* without the guard — the
regression test is void while looking green, and the same applies to
`decodeNonEmptyURLIfPresent`.

- **Capture the fixture from a record that genuinely returns `""`**, and record
  the source ID. Confirm the red step fails as a **thrown** `DecodingError`, not
  as a failed `== nil` assertion — a nil-mismatch failure means the fixture is
  wrong, not the code.
- **A fixture where every key is present cannot catch the sibling mistake.**
  Replacing synthesized `Decodable` with a hand-written `init(from:)` loses the
  compiler's guarantee that optionals use `decodeIfPresent`:
  `try container.decode(String.self, forKey: .character)` assigned to a `String?`
  compiles fine and then throws on every record that omits the key. Pair each
  model with a minimal-JSON test asserting **all** its optionals are `nil` — the
  "without appended data" pairing `CLAUDE.md` mandates is the only thing that
  catches this.
- Prefer a real record that is sparse in *two* ways at once. Here the blank-date
  fixtures are crew credits, which omit `character` entirely, so one fixture
  covers the empty-date branch and an absent-optional branch.

### A `#expect(throws: DecodingError.self)` test is a false green twice over

*2026-08-12 (#432).* Two independent traps when pinning "this input must throw":

1. **Copying `ImageSizeTests` uses a bare `JSONDecoder()`.**
   `ImageSizeTests.swift:49-55` decodes a single-value enum, so it needs no key
   strategy. Reuse that shape for a *keyed* model and there is no
   `.convertFromSnakeCase`, so an inline `{"media_type": …}` literal throws
   `keyNotFound(mediaType)` — never reaching the branch under test. Both are
   `DecodingError`, so the test passes for the wrong reason. Decode via
   `JSONDecoder.theMovieDatabase` and assert the **specific** case
   (`guard case .dataCorrupted(let context)`, then check
   `context.debugDescription`).
2. **`decode(_:fromResource:)` records the failure before rethrowing.**
   `Tests/TMDbTests/TestUtils/JSONDecoder+DecodeFromFile.swift:24` calls
   `Issue.record(error)` and *then* throws, so a fixture-based
   `#expect(throws:)` fails the test even when the throw is exactly what was
   wanted. Throws-tests must build their JSON inline via
   `Data(#"…"#.utf8)` and call `decode(_:from:)`.

### Guard consistently within a type, even for a value the API never sends

*2026-07-28 (#404).* Making `Company.logoPath` optional, the question was whether
the nested `Company.Parent.logoPath` needed the same empty-string guard. The
evidence said no: a 54-company sample found `logo_path` was `""` **zero** times,
and no sibling logo model (`ProductionCompany`, `WatchProvider`, `Network`)
guards it. So `Company` got `decodeNonEmptyURLIfPresent` (free — it already had
a custom decoder) and `Parent` was left synthesized.

That was the wrong cut. It produced an **asymmetry inside a single type**:
`Company.logoPath` mapped `""` → `nil` while `Company.Parent.logoPath` still
threw `DecodingError.dataCorrupted: Invalid URL string` on it — the very failure
the change existed to remove, surviving one level down. The independent rubric
grader caught it; three plan critics had split 2–1 on it beforehand.

- **"Matches the siblings" and "consistent within the type" can conflict.**
  When they do, prefer *within the type* — a reader of `Company.swift` sees both
  properties at once and cannot explain why they differ, whereas the
  cross-model difference is invisible in practice.
- **"The API never sends it" ranks the risk, it doesn't close the case.** It is
  a reason not to build elaborate machinery; it is not a reason to leave two
  neighbouring properties behaving differently for the same input.
- A nested type with synthesized `Decodable` needs its **own** `CodingKeys` +
  `init(from:)` to use the helper — roughly 15 lines. That was the real cost
  being weighed, and it was worth paying.

**Scope of the rule: same value class, not same file.** *2026-08-12 (#432),
where one of three plan critics read this entry as requiring
`decodeNonEmptyURLIfPresent` on `CreditMovie.posterPath` because the neighbouring
`releaseDate` had just been guarded.* That over-applies it. The #404 asymmetry was
two properties of **one value class** — `Company.logoPath` and
`Company.Parent.logoPath`, both logo paths, same wire shape, no explicable reason
to differ. A date behaving differently from a URL is not that: they are different
types with **measured** different API behaviour (see `tmdb-api-notes.md` →
*`/credit/{id}`*: dates are `""`, image paths only ever `null`), and every sibling
model leaves image paths unguarded. The test is *"could a reader explain the
difference in one sentence?"* — not *"are these two lines identical?"*. Guarding
here would have made `CreditMovie` the lone divergence across ~20 models and set
the precedent in all of them.

### Sweeping for a decode bug: sweep the *failure class*, not the property name

*2026-07-28 (#404).* Fixing `Company.logoPath`'s required decode, a
type-driven sweep for `let logoPath: URL` found two sites — the property and
the nested `Company.Parent`. It felt complete. It wasn't: `Company.originCountry`
is the *same bug* in a different property, and the very records that return
`logo_path: null` also return `origin_country: null` — so the fix would have
shipped with its own integration test still failing.

- **The sweep key was wrong.** "Every `logoPath: URL`" is a *name* sweep. The
  real class is **"every required decode on a model whose API returns sparse
  records"** — enumerate the model's `try container.decode(` lines and check
  each against real responses, rather than grepping the field you already know
  about.
- **Nested types hide instances.** `Company.Parent` has no `init(from:)` of its
  own, so its required decode is *synthesized* and invisible to a grep for
  `container.decode`. A file with one custom decoder can still have several
  decoding types — count the types, not the decoders.
- **Sample the population, don't spot-check.** One `curl` of an affected record
  showed `logo_path: null` and stopped the investigation there. Sampling 54
  companies took a minute and produced the whole field/nullability matrix (see
  `tmdb-api-notes.md`) — which is what proved `origin_country` was in scope and
  `description`/`headquarters` were not.
- **The sweep earns its keep by *excluding*, not only by finding.** *2026-08-12
  (#432).* Sweeping the whole `/credit/{id}` response tree did both: it turned up
  an unrelated live decode failure the issue never mentioned (`credit_type:
  "creator"`), **and** it cleared five URL decodes the plan had excluded on a
  single spot-check. The second half is what makes a narrow scope defensible in
  review instead of merely asserted — a measured "we checked, it isn't in the
  class" survives a reviewer; "the API probably never sends that" does not.

### An `async let` binding cannot be captured by `#expect(throws:)`

*2026-07-27 (#401).* Awaiting an `async let` inside the `#expect(throws:)`
closure fails to compile:

```text
error: capturing 'async let' variables is not supported
```

Use an explicit `Task {}` handle instead and await its `.value` inside the macro
— `let caller = Task { try await store.foo() }`, then
`await #expect(throws: TMDbError.unknown) { _ = try await caller.value }`. A
plain `let` task handle is capturable; the `async let` binding is not.

### `Date(iso8601:)` is not visible to `TMDbIntegrationTests`

*2026-06-24, path updated 2026-07-28.* The `Date(iso8601: "…")` convenience
initialiser lives in `Tests/TMDbTestFixtures/TestUtils/Date+ISO8601.swift` — the
**shared fixtures target**, which the unit-test targets get via
`@_exported import TMDbTestFixtures`. **`TMDbIntegrationTests` does not depend on
it** (`Package.swift`: its dependencies are `["TMDb", "TMDbIntelligence"]`), so
the helper is unavailable there. Using it in an integration test fails to compile
with a misleading *"argument passed to call that takes no arguments"* (Swift
resolves `Date(...)` to the argument-less `Date()`).

The integration target has no date-from-string helper; build dates there with
`Date(timeIntervalSince1970:)` (the existing convention, e.g. the
`video.publishedAt` assertions). This only surfaces when the **integration**
target compiles, so `/integration-test` catches it; a unit-only check may not.

> Originally filed as "exists only in the `TMDbTests` target". The helper moved
> to the shared fixtures target in the #398 extraction; the **conclusion**
> was unaffected, which is exactly why the stale path survived so long — the
> advice still worked, so nobody re-read the reasoning.

### Model-decode equality tests: build the expected value directly, not from an over-populated mock

*2026-06-19.* `Network` is `Equatable` over **all six** stored properties
(`id`, `name`, `logoPath`, `originCountry`, `headquarters`, `homepageURL`), and both
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

### Integration tests need live-API env vars, and can fail transiently

- `make integration-test` requires `TMDB_API_KEY` / `TMDB_USERNAME` /
  `TMDB_PASSWORD` (injected via `.claude/settings.local.json`). A missing var is
  a **precondition** failure, not a test failure.
- They hit the **live** API, so HTTP 429 / timeout / network are possible — a
  truncated log with no assertion failure is likely transient, not a code bug.
  Use `/diagnose-integration-failure` to attribute a failure.

## Public API

### A `RawRepresentable` enum with an associated-value case gets **rawValue** equality, not structural

*2026-07-24.* `TMDbStatusCode` is a hand-rolled
`RawRepresentable, Equatable, Hashable` enum with an `.unknown(Int)` escape
hatch. The synthesised `==` is **not** structural: Swift derives it from
`rawValue`, so `.unknown(7) == .invalidAPIKey` is **`true`** (both have raw value
7) even though they are different cases. A test asserting they differ fails.

- This is coherent — equal raw values *should* be equal — but it is easy to
  assume case-identity semantics and write the opposite assertion.
- **Do it deliberately:** implement `==` and `hash(into:)` explicitly over
  `rawValue` and document the semantics, rather than relying on the synthesis.
  Keep construction funnelled through the classifying `init?(rawValue:)` so the
  `.unknown` case can only ever hold an *undocumented* value and the collision
  never arises in practice. See
  [ADR-0012](decisions/0012-structured-tmdberror-context.md).

### `NaturalLanguageSearchService` is not platform-gated — only its `TMDbClient` accessor is

*2026-06-23.* `CLAUDE.md` describes natural-language search as "Apple-platforms
only", which is easy to over-apply. In fact the **protocol** and all its types
(`SearchPlan`, `NaturalLanguageSearchResult`, `NaturalLanguageSearchError`,
`NaturalLanguageSearchAvailability`) only `import Foundation` — **no
`#if canImport(NaturalLanguage)` and no `@available`**. The gating lives solely on
the `TMDbClient.naturalLanguageSearch` *accessor* (and the on-device planner
implementation, e.g. `PersonNameExtracting`, `FoundationModelsSearchPlanGenerator`).
So code that merely conforms to or references the protocol/types (e.g. a mock)
compiles on Linux and must **not** be wrapped in `#if canImport(...)` —
over-gating would needlessly remove it off-Apple. Gate only the specific symbol
that actually imports `NaturalLanguage`/`FoundationModels`.

### A protocol-extension convenience that differs only by a default argument becomes the requirement's witness

*2026-08-07.* Default argument *values* are not part of a function's signature
for witness matching. So this, in a `public extension`, does not do what it looks
like it does:

```swift
protocol P { func f(x: URL?) async throws -> T }          // the requirement

public extension P {
    func f(x: URL? = nil) async throws -> T {             // SAME signature!
        try await f(x: x)                                 // calls *itself*
    }
}
```

The extension member has the same signature as the requirement, so it silently
becomes that requirement's **default implementation**. For any conformer that
omits `f(x:)`, the witness *is* this extension member, and the call recurses
until the stack overflows — where the author intended a compile error. In-package
conformers hide it (they all implement the method); it surfaces for a third-party
conformer, i.e. exactly the case a public protocol exists for.

Give the convenience a genuinely distinct signature instead:

```swift
public extension P {
    func f() async throws -> T { try await f(x: nil) }    // cannot be the witness
}
```

Call sites (`f()`) are unchanged, and omitting the requirement is now a compile
error.

**The idiom was repo-wide, not a one-off.** A census found **91 sites across 15
public protocols**. 37 had exactly one defaulted parameter and were fixed — the
fix costs a single dropped-parameter overload and no call site changes. The
remaining **54 have 2–4 defaults**, where preserving every existing call form
needs the *power set* of overloads (4, 8 or 16 each), so they are deferred to
`next-major.md`. `Scripts/check-defaulted-witnesses.py` holds both invariants — zero
single-default sites, and the multi-default sites must match its `DEFERRED`
allowlist exactly (a set, not a count, so a fix and a regression cannot cancel
out and an empty scan cannot pass green). It runs from `make lint` **and** as
its own step in the CI `Lint` job: that job invokes swiftlint and swiftformat
directly rather than through `make`, so wiring it only into the Makefile would
have left it invisible to CI.

**The first census came out 17 short, and the reason generalises.** It grepped
the *protocol declaration* files. But `AccountService` and `PersonService` keep
their conveniences in a sibling `+Defaults.swift`, so the sweep silently missed
two whole protocols while looking complete. The sweep key here is the failure
class — *"a public-extension member whose parameter list matches a requirement's
after erasing defaults"* — which is a property of the pair, not of a file. Same
lesson as *Sweeping for a decode bug: sweep the failure class, not the property
name*, and the same shape as the `Company.Parent` miss: **enumerate by symbol
relationship, never by filename convention.**

**A conformer that omits the method is the only thing this can hurt, so the test
has to be shaped for that.** Every in-package type implements every requirement,
so nothing in `Sources` can reproduce it, and the *compile error* the fix
restores cannot be asserted from a test at all. What is testable is the other
half of the contract — that the convenience still forwards `nil` — and the
faithful conformers to drive it through are `TMDbTesting`'s mocks, which
implement requirements only and carry no default arguments. Hence
`Tests/TMDbTestingTests/Services/Conveniences/`, a target that imports through
the public API with no `@testable`.

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

### `URL(string:)` on Apple platforms rejects almost nothing — probe before testing a rejection

*2026-07-24.* Trying to test the `TMDbAPIError.invalidURL` branch (thrown when
`URL(string: request.path)` returns `nil`), the only inputs that actually fail on
Apple Foundation are the **empty string** and a malformed bracketed host
(`"http://[bad/x"`). All of these **parse fine**: spaces, tabs, newlines, `NUL`,
emoji, invalid percent-escapes (`%zz`), `<>`, `\`, `^`, `|`.

- So on macOS/iOS that error path is effectively only reachable with an empty
  path — you cannot construct a "token-bearing invalid path" test case there.
- **swift-corelibs-foundation (Linux) parses more strictly**, so the
  branch is not dead code across the package's supported platforms — which is
  why the thrown path is still redacted.
- **Probe empirically** (a throwaway `swift script.swift` with the candidate
  strings) before writing any test that depends on `URL(string:)` returning
  `nil`; the behaviour changed with the swift-foundation rewrite and intuitions
  from older Foundation are wrong.

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

### Caching a credentialed response: the predicate is "needs a user", not "has a header"

*Rewritten 2026-08-07, when v4 lists made this real.* Both caches key on the URL
alone — `CacheHTTPClient` on `request.url.absoluteString`, and the process-wide
`URLCache` on the URL too. A v4 list read carries its user token in a **header**,
so two different users requesting one list send byte-identical URLs: a URL-keyed
cache would serve one user's private list to another.

The fix that looks obvious — bypass any request with an `Authorization` header —
is wrong, and it took a review to notice. A `TMDbClient(bearerToken:)` sends that
header on **every** request, including wholly public ones, because it is the
*application's* API Read Access Token. Keying on the header would disable
caching for every such client while protecting nothing.

So `HTTPRequest.isUserSpecific` is set by `TMDbAPIClient` — the only component
that sees a request *before* the client credential is applied, and can therefore
tell a per-call credential from the client's own. It covers all three user-scoped
mechanisms: a v4 access token, a v3 `session_id`, and a guest session.

The v3 mechanisms matter for a different reason, which is easy to wave away: they
put the credential in the URL, so keys already differ per user and nothing
crosses between them. But the response is still one person's watchlist being
written to a cache that is process-wide and survives relaunch. *No cross-user
leak* is not the same as *safe to store*.

Both layers act on the flag, and both are needed: `CacheHTTPClient` bypasses,
and `URLSessionHTTPClientAdapter` routes through a second session with
`urlCache = nil`. A cache *policy* alone stops a stale read but not the write.
That second session copies the injected session's configuration rather than
building a fresh one — otherwise tests injecting a `MockURLProtocol` session
would silently reach the live network, and the bypass would be untestable.

## Swift concurrency

### Writing a `Task {}` body inside an actor: typed throws and the missing `await`

*2026-07-27 (#401).* Two compiler rules bite together when an actor stores an
unstructured `Task` and commits its result back to the actor (the memo in
`APIConfigurationStore`).

**Typed-throws `do`/`catch` inference does not apply inside a closure.** It works
in a function body, but in a `Task { }` or `group.addTask { }` body a bare
`catch` binds `any Error`:

```text
error: cannot convert value of type 'any Error' to expected argument type 'TMDbError'
```

Write the effect explicitly — `do throws(TMDbError) { … } catch { … }`. An
explicit closure signature (`Task { () async -> Result<…> in … }`) does **not**
fix it. And `catch let error as TMDbError` compiles but emits *"'as' test is
always true"*, which is fatal under `--Werror`. The alternative that also works
is extracting the `do`/`catch` into a plain `private func … async -> Result<…>`
and calling that from the `Task`.

**A `Task {}` capturing `self` inside an actor inherits that actor's isolation.**
So calling back into the actor from the task body must **omit** `await` — a
redundant one is `#UnnecessaryEffectMarker`, also fatal under `--Werror`. With
`[weak self]` the isolation is *not* inherited and `await self?.foo()` **is**
required. Strong `self` is usually what you want: the commit then happens in the
same actor-isolated, suspension-free region as the task's completion.

### Testing a memoising actor: a caller that *joins* is invisible to the mock

*2026-07-27 (#401).* When an actor de-duplicates concurrent work by sharing one
in-flight `Task`, only the **first** caller reaches the underlying mock or gate.
Every later caller awaits the existing handle and never touches the double — so
a `FetchGate`-style barrier cannot observe it, and a test that opens the gate and
then asserts on de-duplication is **flaky by construction**: if the shared fetch
commits first, the "joiner" starts its own fetch and the assertion fails.

- **Fix:** count arrivals on the actor itself — an internal counter incremented
  **before the first suspension point**, which is a true "has joined" signal —
  and poll it. Production cost is one `private(set) var` and one increment per
  entry point; the alternative is a test that asserts a guarantee it cannot
  actually observe.
- **Always bound such a barrier.** An unbounded `while x < n { await Task.yield() }`
  turns the very regression it guards into a **CI hang with no diagnostic**,
  which is strictly worse than a failed assertion. Give it a deadline and
  `Issue.record` on expiry.
- Both traps were found by code review *after* the tests were green, not by
  running them — they are ordering assumptions, not reproducible failures. One
  reviewer measured 0/65 reproductions including 25 under 12-way CPU load.

### Deterministically testing that cancellation is *forwarded* into an unstructured `Task`

*2026-06-18.* An unstructured `Task {}` does **not** inherit its parent's
cancellation. To forward it, await the child inside
`withTaskCancellationHandler { try await task.value } onCancel: { task.cancel() }`
(see the prefetch iterators, [ADR-0003](decisions/0003-opt-in-pagination-prefetch.md)).

Testing the forward is subtle: a naive test asserting the consumer throws
*something* passes even if the forward is dropped, because the iterator's
*pre-await* cancellation guard also throws. To prove the forward
actually fired:

> *Updated 2026-08-12 (#419):* that pre-await guard is now
> `guard !Task.isCancelled else { throw TMDbError.cancelled }`, not
> `try Task.checkCancellation()`, so the two paths are no longer the *same*
> error type — the guard throws `TMDbError.cancelled` while a forwarded cancel
> surfaces whatever the page fetcher throws (`CancellationError` in these
> tests). That makes the confusion less likely but does not remove the need for
> the recorder below: the fetcher's error type is the test's own choice, so
> asserting on it still cannot prove *where* the cancellation came from.

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

**Forwarding is not always right.** It is correct here because the prefetch task
has exactly **one** owner-awaiter. A task shared by **N** awaiters — such as the
configuration memo in [ADR-0013](decisions/0013-cached-image-url-resolver.md) —
must *not* forward, or one cancelled caller fails all the others. Check the
awaiter count before copying this pattern. But "don't forward" does **not** have
to mean "not cancellable" — see the next entry.

### Letting ONE awaiter of an N-awaiter shared task bail out

*2026-08-12.* The complement to the entry above. `Task.value` on a
`Task<_, Never>` is **not a cancellation point**, so awaiters joining a memoised
fetch that way are dragged to its completion — ~30s on a default URLSession
timeout, but **minutes** with retry enabled (`maxRetries: 3`, `maxDelay: 30s`).
The fix is *not* to forward cancellation into the shared task; it is to give each
awaiter its own exit:

```swift
let box = ResumeOnce<Result<Value, MyError>>()
let outcome = await withTaskCancellationHandler {
    await withCheckedContinuation { continuation in
        box.attach(continuation)              // runs in the actor's isolation
        Task { box.resume(await shared.value) }  // unstructured: no inherited cancel
    }
} onCancel: {
    box.resume(.failure(.cancelled))          // synchronous — no actor hop
}
```

Four things make this work, and each is load-bearing:

- **A lock, not an actor**, for the box. `onCancel` is a **synchronous**
  nonisolated closure — it cannot `await` a hop onto an actor. Hopping via
  `Task { await … }` instead makes cancellation delivery *race* the shared task's
  completion, which is precisely the "flaky by construction" shape this file
  warns about elsewhere. Same reasoning as `DataTaskBox` in
  `URLSessionHTTPClientAdapter`.
- **Resume outside the lock.** Resuming a continuation while holding the lock can
  re-enter the awaiting code on the same thread.
- **The box holds *either* the continuation *or* a pending value**, whichever
  arrives first, plus a `hasResumed` flag — because `onCancel` can fire *before*
  the continuation is installed. Latch the first pending value: without
  `if pendingValue == nil`, "first call wins" silently becomes "last wins".
  (`pendingValue == nil` needs no `Equatable` on `Value` — it binds the
  unconstrained `Optional` overload.)
- **The observer `Task` is unstructured**, so it does not inherit the awaiter's
  cancellation and the shared fetch still runs on and commits for everyone else.

Rejected alternatives, both worse: a **waiter registry** keyed on the actor
introduces a late-registration hang class (a waiter registered after its fetch
drained is never resumed) that `await task.value` cannot have, since it returns
immediately for an already-finished task; and **racing via `withTaskGroup`**
does not work at all, because the losing child awaiting `.value` is itself
uncancellable and the group awaits every child at scope exit.

**Test the box directly.** Driven only through the store, first-wins and
last-wins are indistinguishable — and the failure mode of a future edit is a
`SWIFT TASK CONTINUATION MISUSE` crash or a hang, not a red assertion. Also put
`.timeLimit` on any suite that exercises such a join: a lost continuation
otherwise burns the CI job's default timeout with no diagnostic.
See [ADR-0018](decisions/0018-cancellation-as-tmdberror-case.md).

### A local named after a stored property reads **uninitialised memory** inside its own initialiser

*2026-08-12 (#419/#433).* This compiles, passes every macOS test, and segfaults
on Linux:

```swift
private var continuation: CheckedContinuation<Value, Never>?   // stored property

func resume(_ value: Value) {
    let continuation: CheckedContinuation<Value, Never>? = lock.withLock {
        guard let continuation else { … return nil }   // ← NOT self.continuation
        self.continuation = nil
        return continuation                            // ← returns garbage
    }
}
```

Inside the closure that *initialises* the local, the bare name `continuation`
binds the **local being declared**, not the property — and at that point it holds
uninitialised stack memory. Definite-initialisation analysis does not catch it
through the closure, so there is no warning. The read is undefined behaviour:
on Darwin the stack garbage happened to be `nil`, so the `guard` took its `else`
branch and the code behaved perfectly; on Linux/aarch64 it was non-`nil`, so the
guard fell through and returned a bogus pointer, crashing in `swift_retain`
(`Bad pointer dereference at 0x107`).

- **Symptom to recognise:** a crash or hang *only* on Linux, in a function whose
  local shares a name with a stored property. The backtrace points at the
  `return` inside the `withLock`/closure, which "cannot" be reached.
- **Fix:** name the local something else (`waiting`, `attached`) **and**
  `self.`-qualify every property access in the closure. Renaming alone is enough
  for the compiler; the qualification is what stops it being reintroduced.
- **Why review missed it:** it is invisible in a diff — the code reads exactly
  like the correct version. `claude-review` explicitly approved the file. Only
  running it on a second platform found it.

**Corollary — a fully green `make ci` does not cover this.** `make ci` never
builds for Linux (see *`make ci` skips the Linux build*), so
`build-test-linux` is the only gate that can catch platform-dependent UB. For
any hand-rolled concurrency primitive, run `make test-linux` **before** opening
the PR: a blind CI round-trip costs ~45 minutes *and* a manual force-cancel,
because a hang wedges the runner and ignores GitHub's cancel.

### `.timeLimit` does not rescue a task parked on an unresumed continuation

*2026-08-12 (#419/#433).* A Swift Testing `.timeLimit` trait cancels the test's
task — but a task suspended on a `CheckedContinuation` that is never resumed is
**not cancellable**, so the timeout itself blocks. Observed directly: 17 tests in
the neighbouring suites correctly recorded *"Time limit was exceeded: 60.000
seconds"*, while the suite holding the leaked continuation recorded **nothing at
all** and kept `swift test` alive indefinitely — the job then ignored both the
GitHub concurrency cancel and `gh run cancel`, and needed a `force-cancel`.

So `.timeLimit` is worth adding (it converts *slow* into *failed*, and it did
localise the blast radius here), but do not describe it as protection against a
lost continuation. The real backstops are a job-level `timeout-minutes`
(absent on this repo's `build-test*` jobs — issue #435) and testing the
primitive directly so the leak never ships.

### `withCheckedContinuation`'s body runs in the enclosing actor's isolation

*2026-08-12.* Since Swift 5.10 `withCheckedContinuation` /
`withTaskCancellationHandler` take `isolation: isolated (any Actor)? = #isolation`,
and the body closure is non-`Sendable` and runs **synchronously on the caller's
executor**. Called from an actor-isolated method, the body is therefore
actor-isolated: registering state there cannot interleave with the actor's own
mutations, and no `await` is needed (adding one is an
`#UnnecessaryEffectMarker` error under `--Werror`). The repo already relied on
this in the test-only `FetchGate`. What it does *not* buy you is protection from
a **nonisolated** producer such as a cancellation handler — that still needs a
lock.

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
