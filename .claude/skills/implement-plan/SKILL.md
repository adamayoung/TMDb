---
name: implement-plan
description: Implement the current plan test-first, the Canon TDD way, driving to a single finishing condition — an empty test list. Derives a Canon TDD test list from the plan, shows it before any code, writes one failing test at a time, and keeps the list visible as it evolves. Use when the user asks to implement, build, or execute the current/approved plan.
---

# Implement Plan

Turn the **current plan** into working, tested code — strictly test-first. This
skill is the wrapper that ties three things together: the plan (what to build),
the **`canon-tdd`** skill (how to build it), and a single finishing condition —
**the test list is empty** (when to stop). It does not invent its own TDD rules;
it delegates the discipline to `canon-tdd` and adds plan-awareness, the finishing
goal, and the project's specialist skills.

> Red-Green-Refactor is the engine. The test list is the steering wheel. This
> skill keeps the wheel on screen and drives until the list is empty.

## Agent Behaviour Contract

These are non-negotiable. Do them by default, without being reminded.

1. **Canon TDD is mandatory — invoke the `canon-tdd` skill.** No production code
   before a failing test. One test at a time. Refactor only on green. This skill
   exists to enforce that loop against the plan; do not freelance an
   implementation-first approach.
2. **Show the test list before any code — and every time it changes.** Print the
   Canon TDD test list as a checklist before the first edit, and re-print it
   whenever you add, remove, reword, or check off an item (see *Keep the test
   list visible*).
3. **The finishing condition is an empty test list.** "Done" means every item on
   the list has a written, passing test and the full suite is green — nothing
   less. Pair this with the `/goal` command for autonomous cross-turn iteration
   (see *Set the finishing goal*).
4. **Reach for the right specialist skill.** Use `swift-testing-expert` when
   writing/structuring tests and `swift-concurrency` for anything touching
   tasks, actors, `@MainActor`, `Sendable`, or data races — don't hand-roll what
   those skills know.
5. **Document every public declaration — no exceptions.** Documenting it is part
   of "make it pass". Every public protocol, class, struct, enum, actor, model,
   property, initializer, method, subscript, and typealias you add or change MUST
   carry an accurate `///` doc comment, and the DocC catalog must stay in sync
   (see *Document every public declaration*). This is mandatory, not optional —
   `make build-docs` runs warnings-as-errors, so an undocumented public symbol is
   a build failure.
6. **Expect Swift files to change after you write them.** A PostToolUse hook runs
   `swiftlint --fix` + `swiftformat` on every `.swift` file you Edit/Write, so the
   on-disk content can differ from what you wrote (see *The lint/format hook*).
7. **Commit at logical checkpoints — always green.** Like a human engineer, commit
   when a cohesive increment is complete and the code is in a **good state**, and
   **never commit a red or half-finished tree** (see *Commit at logical points*).
   This keeps the work committed as you go, so a downstream review sees real
   history rather than an empty diff.
8. **Finish with the completion checklist.** Before declaring done, run `/test`
   and `/integration-test` — both REQUIRED to pass per `CLAUDE.md` — plus
   `/lint`, and `make build-docs` whenever public API changed.

## Locate the plan

Use the first that applies, then restate the plan's goal in a sentence so the
test list is anchored to it:

1. **An explicit target** the user named — a plan/design file path, or plan text
   passed as the skill argument.
2. **The active plan-mode plan** — the most recent plan you presented via
   `ExitPlanMode`.
3. **A plan in the conversation** — the most recent structured plan / task
   breakdown (including a `TodoWrite` list framed as the plan).

If there is no plan, stop and say so — offer to draft one first (e.g. via the
`Plan` agent or plan mode), and to `/review-plan` it before implementing. Never
fabricate a plan in order to implement it.

## Step 1 — Derive and show the test list

Invoke the **`canon-tdd`** skill and follow its five steps. Start by translating
the plan into a **test list**: enumerate every behaviour, edge case, and error
path the plan implies — as a plain checklist, not code. For this package that
means thinking about: each new/changed public method, Codable decode paths
(every optional/appended branch — one fixture item per branch), empty/degenerate
inputs at public boundaries, `Sendable`/concurrency expectations, and
Linux/Windows portability.

**Print the list before writing any code**, e.g.:

```text
Test list — <plan goal>
- [ ] decodes <X> with all appended fields present
- [ ] decodes <X> with appended fields absent → optionals are nil
- [ ] <service>.<method>() builds the expected request URL + query items
- [ ] <method>() throws on empty/degenerate input
- [ ] integration: <method>() returns live data
```

It is a living list — you will add cases as implementation reveals them. Confirm
it with the user (or state it explicitly) before proceeding.

## Step 2 — Set the finishing goal

The completion condition for this whole effort is: **the test list is empty** —
every item has a written, passing test, and `make test` + `make integration-test`
are green, with no unrelated files modified.

For autonomous, cross-turn iteration toward that condition, use Claude Code's
`/goal` command. **You cannot set `/goal` yourself — it is user-initiated** — so
offer the user the exact command to run, then proceed with the TDD loop either
way:

```text
/goal every item on the Canon TDD test list has a written, passing test and
`make test` and `make integration-test` both pass — without modifying files
unrelated to this plan; or stop after 25 turns
```

If the user sets it, Claude keeps taking turns until a fast model confirms the
condition. If they don't, drive the same loop yourself across the turn until the
list is empty. Either way the destination is identical: zero unchecked items.

## Step 3 — The TDD loop (one test at a time)

Per `canon-tdd`, repeat until the list is empty:

1. **Pick the next item** and write exactly **one** test (use
   `swift-testing-expert` for structure — `@Test`/`#expect`/`#require`,
   parameterisation, tags). Run it; watch it fail for the right reason.
2. **Make it pass** with the simplest production change that works — resist
   solving items still on the list. **Any public symbol you introduce here is
   documented in the same step** (see *Document every public declaration*) — a
   public declaration without a `///` comment is not "passing".
3. **Refactor only on green**, keeping every test passing and every public symbol
   documented.
4. **Update the list** — check off the item, and add any new cases the work
   revealed — then **re-print the list**.
5. **Commit when you reach a logical checkpoint** — when the increment is cohesive
   and green (see *Commit at logical points*). Not every micro-cycle; at
   meaningful milestones.

Add JSON fixtures under `Tests/TMDbTests/Resources/json/` as decode tests demand,
and a paired integration test under `Tests/TMDbIntegrationTests/` for new public
behaviour. Use the TMDb MCP server (`mcp__tmdb__*`) to source real responses for
fixtures rather than guessing structure.

## Commit at logical points

Build the change as a human engineer would — a sequence of small, working commits,
each a coherent step — not one giant uncommitted blob at the end.

**When to commit** — at a *logical checkpoint*, when a cohesive increment is
complete: a model + its decode tests; a service method + its unit (and
integration) tests; a finished refactor; the fixtures + docs for a unit. Group a
few related test-list items into one commit rather than committing every single
red→green micro-cycle. A good commit tells a story ("✨ Add TVSeason watch
providers endpoint", "✅ Cover decode branches for …", "♻️ Extract …").

**Good state before every commit — never commit red:**

- The suite is **green** — run `/test` (and `/integration-test` if the increment
  touches live-API behaviour) and confirm it passes.
- **Lint is clean** — `/lint` (the format hook handles most of it on write).
- **No half-finished or dead code** — no commented-out experiments, no stubbed
  function you haven't returned to, no debug prints. The tree compiles and every
  public symbol you added is documented.

If an increment isn't green yet, finish it (or stash the unfinished part) before
committing — a commit is a *working* state. Use a gitmoji-prefixed message (see
`CLAUDE.md`). Committing as you go means that by the time the test list is empty,
the work is fully committed — ready for review and PR with a clean history.

## Document every public declaration

Every public symbol you add or change MUST have an accurate `///` documentation
comment — this is a hard requirement (`CLAUDE.md`), and `make build-docs` runs
warnings-as-errors, so a missing one breaks the build. Document **as you write
it**, in the same green step — never as a clean-up pass at the end.

This covers **all** public declarations, no exceptions:

- **Types** — `protocol`, `class`, `struct`, `enum`, `actor`, `typealias`, and
  every model.
- **Members** — stored and computed `properties`, `initializers`, `methods`,
  `subscripts`, `enum` cases where meaning isn't obvious, and associated values.
- **Custom `Codable`** — `init(from:)` and `encode(to:)` in a `public extension`
  need `///` comments too (a common miss).

Quality, not just presence:

- Use correct DocC syntax — `- Parameter name:` (singular) for one parameter,
  `- Parameters:` (plural) for several; `- Returns:`; `- Throws:`.
- Write complete, specific descriptions — never placeholders (`/// ?`,
  `Array of...`). Watch for copy-paste errors (e.g. "movie" left in a Person
  doc, or `Movie.ID` where `Person.ID` is meant).
- Keep the **DocC catalog in sync** when public API changes: the service
  extension file (`TMDb.docc/Extensions/<Service>Service.md`), the catalog
  (`TMDb.docc/TMDb.md`) for new return types, `TMDbClient.md` for new
  properties, and the `README.md` service table — per the Documentation
  Consistency Checklist in `CLAUDE.md`.

Apply the **`document-swift`** skill — the project's single source of DocC
conventions — inline as you write each public symbol. For a bulk pass (a whole
new service, or sweeping many undocumented symbols at once), delegate to the
**`documentation-writer`** agent, which follows the same skill in an isolated
context. Add a "document public API" item to the test list when a behaviour
introduces public surface, so it can't be silently skipped.

## Keep the test list visible

The list is the user's window into progress. Re-print the full checklist (done +
remaining) whenever it changes — after checking off an item, after discovering
and adding a new case, after rewording or removing one. Each re-print should make
clear what just changed (e.g. "✓ added", "✓ done", "✗ removed — superseded by …").
Never let code changes outpace a stale on-screen list.

## Use the right specialist skills

- **`swift-testing-expert`** — when writing or restructuring tests: macro usage,
  `#require` over force-unwrap, traits/tags, parameterised tests, async waiting.
- **`swift-concurrency`** — when the plan touches tasks, actors, `@MainActor`,
  `Sendable`, async/await conversion, or any data-race / Swift 6 strict-concurrency
  diagnostic.
- **`document-swift`** skill — the DocC conventions to apply inline for every
  public declaration; **`documentation-writer`** agent for bulk doc sweeps (see
  *Document every public declaration*).
- **`/test`, `/integration-test`, `/build`, `/lint`, `/format`** — delegate
  builds and test runs to these (they fan out to a Haiku subagent and keep this
  context lean); don't call `make` directly for them.

Invoke a specialist skill the moment its domain appears — not after you've
already hand-written something it would have done better.

## The lint/format hook (files change after you write them)

A `PostToolUse` hook matches `Edit|Write` and, for any `.swift` file, runs
`swiftlint --fix` then `swiftformat` on it. Consequences to plan around:

- **The file on disk may differ from what you wrote** — imports reordered,
  whitespace/indentation normalised, trailing commas adjusted, `self.` removed,
  etc. This is expected and correct; do not fight it or revert it.
- **Re-Read a `.swift` file before your next Edit to it** if that edit depends on
  exact surrounding text — a stale `old_string` (pre-format) can fail to match.
- **Don't attribute hook reformatting to your own diff.** When reviewing changes,
  separate "what I changed" from "what the formatter normalised".
- It only autofixes the single edited file, not the whole tree, and it cannot fix
  real compile errors — so still run `/lint` and `/test` before finishing.

## Done — when the test list is empty

When every item is checked off:

1. Run `/test` and `/integration-test` — both must pass (`CLAUDE.md` requires it).
2. Run `/lint` (and `/format` if needed); run `make build-docs` and
   `/lint`-markdown only if public API or docs changed.
3. Print the final, fully-checked test list and a short summary of what was
   implemented.
4. If a `/goal` was set, it clears automatically once the condition is confirmed.

Do not declare the plan implemented while any test-list item is unchecked or any
required suite is red. An empty list with green suites — that is the finish line.
