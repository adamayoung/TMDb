---
name: canon-tdd
description: Implement features and fix bugs test-first, the Canon TDD way (test list → one test → make it pass → refactor → repeat). Use when implementing any new feature, endpoint, model, or method, fixing a bug, or executing a plan — write the test list and a failing test BEFORE production code.
---

# Canon TDD

Test-driven development the way Kent Beck describes as "Canon TDD", per
<https://adam-young.co.uk/blog/canon-tdd/>. CLAUDE.md mandates a TDD approach for
this package; this skill is the detailed how.

> **Red-Green-Refactor is the engine. The Test List is the steering wheel.**

## Agent behaviour contract

The point of this skill: do these by default, without being reminded.

1. **Start with a test list, and show it.** Before touching production code,
   enumerate the behaviours and edge cases as a checklist and confirm it with the
   user (or state it explicitly). This is the steering wheel — it defines "done".
2. **No production code before a failing test.** Write exactly **one** test,
   run it, and watch it fail for the right reason. Never write the implementation
   first and back-fill tests.
3. **One test at a time.** Do not convert the whole test list into code up front
   — the first passing test often forces a design change that affects the rest.
4. **Refactor only on green**, and keep refactoring out of the make-it-pass step.
5. **Repeat until the test list is empty**, adding newly-discovered cases to the
   list as you go.

## The five steps

1. **Write a test list** — every behavioural variant and edge case you can think
   of, as a plain checklist. Not code yet. It's a living list: add to it whenever
   implementation reveals a new case.
2. **Write a test** — pick the next item and write one real, automated test:
   setup, invocation, and **assertions**. Define *what* the system does and *how
   it's invoked* — not how it works inside. Run it; confirm it fails.
3. **Make it pass** — change the system to satisfy that test with the simplest
   thing that works. Nothing more; resist solving items still on the list.
4. **Optionally refactor** — improve names, structure, and duplication while every
   test stays green. Skip if there's nothing to improve.
5. **Repeat** — next item, until the list is empty.

## Separate interface from implementation

A test fixes a *decision* about the interface (the call shape, inputs, outputs)
and should be silent about the internals. Tests that assert on private mechanics
break under refactoring and defeat step 4.

## Anti-patterns (don't)

- **Tests without assertions** — a test that invokes but asserts nothing proves
  nothing.
- **Pre-converting the whole list to code** — write one test, learn, then the
  next. Batching tests locks in design decisions before you've learned anything.
- **Mixing refactor into make-it-pass** — keep "make it work" and "make it clean"
  as separate steps on either side of green.
- **Premature abstraction from duplication** — a little duplication across two
  green tests is fine; abstract when the shape is clear, not at the first repeat.

## In this codebase (TMDb)

Apply the loop with the project's tooling and conventions:

- **Framework:** Swift Testing — `@Suite`, `@Test`, `#expect`, `#require`. Never
  force-unwrap in tests; unwrap optionals with `try #require(...)`.
- **Run tests via the delegated skills**, not `make` directly, so output stays
  out of context: `/test` (unit) and `/integration-test` (live API). Re-run after
  each red→green and after refactoring.
- **Both layers are required for new behaviour.** Unit tests with JSON fixtures
  AND integration tests against the live API — put both kinds of items on the
  test list from the start.
- **Models / new endpoints:** when the test list involves decoding, the fixture
  must exercise **every** decode branch (all N optional appended properties, plus
  a paired "without appended data" test that asserts they're `nil`). Use the TMDb
  MCP server (`mcp__tmdb__*`) to fetch **real** API responses for fixtures rather
  than inventing JSON — see CLAUDE.md → "Workflow for New Endpoints".
- **Bug fixes:** the first item on the list is a test that **reproduces the bug**
  (red), then the fix (green) — never fix first.
- **New public API:** the test list should include the doc/DocC and README
  updates as completion items, even though they aren't tests (CLAUDE.md
  consistency checklist).

## When NOT to use it

Pure refactors with existing coverage, formatting, config/CI edits, and docs-only
changes don't start from a new failing test — keep the existing tests green
instead. TDD is for *new behaviour* and *bug fixes*.
