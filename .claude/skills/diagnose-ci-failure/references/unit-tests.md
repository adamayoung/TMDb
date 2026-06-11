# Unit-test failure (Build and Test — test step)

The **Build and Test** job runs the unit suite:

```
swift test --filter TMDbTests --enable-code-coverage --xunit-output junit.xml
```

Tests use the **Swift Testing** framework (`@Suite`, `@Test`, `#expect`,
`#require`) — not XCTest. Output is piped through `xcsift`, so failures appear as
annotations with the failing `Suite/test` and `file:line`.

## Reading the failure

- A recorded `#expect(...)` failure prints the expression and the actual vs
  expected values at `file:line`.
- A `#require(...)` failure throws and aborts that test (used to unwrap
  optionals) — the message names what couldn't be unwrapped.
- A thrown `DecodingError` (`keyNotFound`, `valueNotFound`, `typeMismatch`) means
  a JSON fixture no longer matches the model that decodes it.

## Common causes & fixes

1. **Assertion failure from changed logic.** The test encodes the old behaviour;
   either the change is wrong, or the test needs updating to the new expected
   value. Decide which — don't blindly "fix" the test to match a bug.

2. **Fixture ↔ model mismatch** (most common for model changes). A model gained,
   renamed, or re-typed a property but its JSON fixture in
   `Tests/TMDbTests/Resources/json/` wasn't updated (or vice versa):
   - `keyNotFound "x"` → the model requires `x` (non-optional) but the fixture
     omits it. Add it to the fixture, or make the property optional if the API
     can omit it.
   - `valueNotFound` / `typeMismatch` → the fixture's value is `null` or the
     wrong JSON type for the model's property type.
   - Per CLAUDE.md, fixtures must exercise **every** decode branch: if a custom
     `init(from:)` decodes N optional appended properties, the fixture must
     include all N, paired with a "without appended data" test.

3. **Missing `#require` unwrap** — a new test force-unwrapped (`!`) instead of
   `try #require(...)`; if it crashed rather than recorded a failure, switch to
   `#require`.

## Reproduce locally

- `/test` — runs the full unit suite (Haiku subagent, logs to
  `.build/last-test.log`).
- Single test: `swift test --filter "SuiteName/testName"`.

## Output

**Summary:** Build and Test — test step — `Suite/test` at `file:line`.
**Cause:** the assertion or fixture/model mismatch (name the fixture + model).
**Fix:** update fixture `X.json` / model `Y` (or the assertion); re-run `/test`.
