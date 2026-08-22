# Build and Test Tooling

> Topic doc referenced from [`CLAUDE.md`](../../CLAUDE.md). Read before
> building or testing, choosing between `make`, the skills and Xcode, or
> running builds across worktrees.

## Prefer the Project Skills (Delegated to Haiku)

For builds and test runs, invoke the project skills rather than calling `make`
or the Xcode MCP directly: `/build`, `/build-for-testing`, `/test`, and
`/integration-test`. Each spawns the shared `tooling-runner` agent
(`.claude/agents/tooling-runner.md`, pinned to Haiku), which runs the command,
writes the full output to a `.build/last-*.log` file, and returns only a
concise summary (status, counts, failures as `file:line`) — keeping context
lean. Its report is a **contract**: a `Directory:` and a `Status:`
line, always. `Status: refused` means a caller bug (wrong or missing package
directory) — surface it, never fall back; a report missing those lines means
the subagent died, so the run is *void* rather than failed — re-invoke once,
then fall back to `make -C <dir>` and say that you did.

`/lint` and `/format` run `make` directly (they are fast and low-output), and
`make ci` is run directly before a PR.

## Common Commands

The full command set lives in the `Makefile`; prefer the skills above over raw
`make`. The mandatory pre-PR gate is `make ci` (lint, lint-markdown, test,
integration-test, build-release, build-docs). A **single test** is the
sanctioned direct exception to the delegate-to-Haiku rule — its output is
small enough to run inline via `swift test --filter "Suite/test"`.

There is no `make test-ios` target. Run simulator tests
(iOS/watchOS/tvOS/visionOS) from Xcode using the **TMDb** (unit) or
**Integration** test plans.

**The `.xctestplan` files are gitignored (`.gitignore:9`) and untracked**, so a
fresh clone has neither and this Xcode route is unavailable until you create
them locally. Nothing in CI depends on them — CI and `make` both drive SwiftPM
directly — so a contributor without them loses only the simulator route, not
coverage. Don't plan work that edits them: they are not in the repo (a plan once
scheduled a sweep over files that don't exist, #398). **Worktrees do get them**,
via `.worktreeinclude`. `Integration.xctestplan` stores the TMDb credentials as
literal values, since Xcode can't read `settings.local.json` — treat it as
credential-bearing.

## Navigating Swift: Prefer the LSP over `grep`

For **symbol-level** questions, ask SourceKit-LSP rather than searching text.
`LSP` is a *deferred* tool, so load it once per session with
`ToolSearch("select:LSP")` — until then `Grep` is the reflex and the LSP simply
goes unused.

- `findReferences` / `incomingCalls` — who actually calls this. Grep hits here
  are polluted by mocks, DocC comments and string literals.
- `goToImplementation` — what conforms to this protocol (the protocol-backed
  services make this the common question).
- `hover` — a symbol's real type behind `any`, a generic, or a typealias.
- `workspaceSymbol` fuzzy-matches **very** loosely (`MovieService` returned 1161
  symbols); treat it as candidate generation, not lookup.

Two practical notes: the first call can fail with *server is starting* — that is
a cold start, retry once; and positions are 1-based with the character landing
**on** the symbol, or you get a silent "no hover information".

**Keep `grep` for** exact strings, JSON fixtures, Markdown, and non-Swift files.
The distinction that matters: grep answers *"what text appears where"*, the LSP
answers *"what does the compiler think this is"* — and for "find every site that
does X", only the second is trustworthy. ADR-0008 prescribed a grep to find
every path interpolation; it found four of eight, and the three it missed
carried a bearer-like credential for two months (issue #421).

## Inside Xcode vs. Terminal

Outside Xcode (terminal Claude Code), the skills fall back to `make`
(`make build` / `make test` / `make integration-test`); the `mcp__xcode__*`
server that `.mcp.json` registers is what a terminal session gets, but the
`make` route is preferred there. Inside Xcode (the native Claude Agent
integration) use the `mcp__xcode-tools__*` tools — which exist **only** inside
that integration, not in a terminal session. The full tool list, test-plan
selection (**TMDb** unit / **Integration**), and the xcsift output-formatting
details (`-f toon` local vs `-f github-actions` CI, `--Werror`, `pipefail`) are in
[`knowledge/gotchas.md`](../../knowledge/gotchas.md) under **Tooling**.

## Build Isolation and Sequential Builds

The `make` targets build with SwiftPM (`swift build`/`swift test`), not
`xcodebuild`, so there is no `-derivedDataPath`; the equivalent is the
scratch directory. Every target accepts an overridable `SCRATCH_PATH`
(default `.build`):

- Run builds **sequentially** within a worktree — concurrent `swift build`s
  fight over the same `.build` and cause SwiftPM lock contention and hangs.
- When multiple agents build at once in **separate git worktrees**, give each
  its own scratch dir, e.g. `make test SCRATCH_PATH=.build/agent-a`. Any path
  under `.build` is already covered by the `/.build` `.gitignore` rule.

## Shell Environment

Run shell commands directly — do not prefix them with
`source ~/.zshrc`. Required environment variables (`TMDB_API_KEY`,
`TMDB_USERNAME`, `TMDB_PASSWORD`) plus the two v4 credentials
(`TMDB_API_READ_ONLY_TOKEN`, `TMDB_API_USER_TOKEN` — without them the v4 suites
skip) are injected via the `env` block in `.claude/settings.local.json`, and
Homebrew tools (`gh`, `swiftlint`, `swiftformat`, `xcsift`, `markdownlint`) are
already on `PATH`.

```bash
make integration-test
gh pr create ...
```
