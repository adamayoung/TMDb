# Testing

> Topic doc referenced from [`CLAUDE.md`](../../CLAUDE.md). Read before
> writing or organising tests, or adding a test target. The always-on testing
> rules (TDD via `canon-tdd`, both suites must pass, fixture completeness,
> `#require` over force-unwrap) are stated in `CLAUDE.md` — this doc carries
> the detail behind them.

## Test Organization

- `Tests/TMDbTests/` — core unit tests with JSON fixtures (`Resources/`)
- `Tests/TMDbTestFixtures/` — **shared** mocks, `.mock` model factories, and
  test utilities (`Tags`, `Date+ISO8601`, `MockAPIClient`), at `package`
  access so both unit-test targets share one copy. It has no library product
  and is re-exported via `@_exported import TMDbTestFixtures`, so test files
  need no explicit import. Mocks of *internal* TMDb types stay in the target
  that `@testable`-imports them.
- `Tests/TMDbIntelligenceTests/` — unit tests for the intelligence module
- `Tests/TMDbTestingTests/` / `Tests/TMDbIntelligenceTestingTests/` — the
  testing kits, exercised through **public imports only** (no `@testable`)
- `Tests/TMDbIntegrationTests/` — live API tests
- Uses **Swift Testing** framework (`@Test`, `#expect`, `#require`) — not
  XCTest

## Adding a Test Target

Test-target names are hardcoded in **five** places — miss one and the failure
is silent:

1. `Makefile` — `TEST_TARGET`.
2. `.github/workflows/ci.yml` — the macOS `Test` step's `--filter`.
3. `.github/workflows/ci.yml` — the Linux `Test` step's `--filter`.
4. `.github/workflows/ci.yml` — the **`unit-test-timezones`** `Test` step's
   `--filter` (the `TZ` matrix job).
5. `.github/workflows/ci.yml` — the **`Prepare Code Coverage`** loop
   (`for target in …`), which enumerates one `.xctest` bundle per target.

Miss 1–4 and the suite never runs there; miss 5 and it runs but its coverage is
never exported, so the code it covers reads as uncovered on codecov. Miss 4
specifically and the new target is never proven time-zone-independent.

## Test-Driven Development

Use a TDD approach — **follow the `canon-tdd` skill**: write a test list, then a
failing test (unit **and** integration) before any production code, implement the
minimum to pass, then refactor green. For bug fixes, write a reproducing test
first.

## Always Run Both Unit Tests AND Integration Tests

- **Unit tests** (`/test`; `make test` is the direct fallback) verify logic
  with mocked data and JSON fixtures
- **Integration tests** (`/integration-test`; `make integration-test` is the
  direct fallback) validate against the live TMDb API

Unit tests alone can pass even when JSON fixtures don't match actual API
responses, fields are missing from models, or the API structure has
changed. Integration tests catch these issues.

## Test Coverage

- **New features**: unit tests AND integration tests
- **Bug fixes**: test that reproduces the bug, then the fix
- **Refactoring**: existing tests must still pass; add tests for gaps
- **Model changes**: unit tests with JSON fixtures AND integration tests

## JSON Fixture Completeness

JSON fixtures must exercise **every code path** in the decoder. If a
custom `Decodable` init has separate branches for each optional
property, the fixture must include **all** of those properties — not
just a representative subset. Untested branches hide bugs.

- When a model decodes N optional appended properties, the fixture
  must include all N (use minimal data — one item per array is fine)
- Always pair with a "without appended data" test that verifies all
  optionals are `nil` when absent
- Never assume that "if one branch works, the rest will too" — each
  branch has its own `CodingKeys` and decoding logic

## Never Force Unwrap in Tests

Always use `#require()` instead of `!` for optionals:

```swift
// BAD
let item = result.items.first { $0.id == 42 }!

// GOOD
let item = try #require(result.items.first { $0.id == 42 })
```
