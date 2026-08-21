# ADR-0029: Day-precision dates are interpreted at GMT

- **Status:** Accepted (in 20.0.0, unreleased)
- **Date:** 2026-08-18
- **Deciders:** Adam Young

## Context

TMDb sends two shapes of date. Timestamp-precision values
(`"2016-02-08 14:39:36 UTC"`, `"1999-10-15T00:00:00.000Z"`) carry a zone and
have always decoded unambiguously. **Day-precision** values (`"1999-10-15"`)
carry none, so the zone is ours to choose — and the library chose the machine's
current one, because the strategy inherited its configuration from an older
`DateFormatter` that simply never set a zone.

That made the same wire value a **different instant on every machine**. A server
on UTC and a device on UTC+13 disagreed by up to 26 hours, so the "same" release
date compared unequal across platforms, and any GMT-based re-formatting could
display the previous day.

The outbound half was worse than representational. `DateFormatter.theMovieDatabase`
renders `Date` query parameters for the `discover` and `changes` endpoints, so a
caller west of Greenwich asked TMDb for the **wrong calendar day**:
`2024-01-01T00:00:00Z` went out as `start_date=2023-12-31` at UTC-8. Four
existing request tests asserted a fixed day from a fixed instant and passed only
because CI runs at UTC.

The package was also already inconsistent with itself: `MediaListItem` parsed
day-precision dates at GMT via its own `.iso8601` strategy, so one process could
resolve `"2025-10-26"` to two different instants depending on which type decoded
it.

## Decision

**Day-precision dates are interpreted at GMT, in both directions.**

- `JSONDecoder.theMovieDatabaseDateStrategy` pins `timeZone: .gmt`. The v4
  decoder falls back to this same strategy, so both API versions stay in step.
- `DateFormatter.theMovieDatabase` pins `timeZone = .gmt`. Both halves must move
  together: pinning only the decoder would leave the query-parameter bug in
  place *and* break the ~30 test files that derive expectations from that
  formatter, which pass today only because both sides drift together.

GMT rather than local because a calendar day with no zone is a *fact about the
data*, not about the reader. Local made the value depend on who was asking, which
is the property that made it wrong. `CalendarDate` — a date-only type, the
semantically correct model — was considered and declined; day-precision values
stay `Date`, and nothing is queued in `next-major.md` for it.

### Two carve-outs, both deliberate

**1. "What year is it" stays local.** In `SearchPlanExecutor`,
`startOfYear`/`endOfYear`/`year(of:)` moved to GMT because they build instants
that are fed to the now-GMT formatter, and read years out of instants decoded at
GMT midnight. But `currentYear()` keeps the **ambient** calendar, because it
answers a question about the user's wall clock: someone in Los Angeles saying
"this year" at 18:00 on 31 December means the year on their own calendar.
`FoundationModelsSearchPlanGenerator`, which seeds the model's notion of the
current year, stays ambient for the same reason and is commented to say so.
Pinning both would have rolled "this year" forward eight hours early for every
negative-offset user and desynchronised the planner from the executor.

**2. `MediaListItem` keeps its own parse strategy.** It looks like duplication
now that the shared strategy is also GMT, and the original plan for this change
called for consolidating them. The substitution was implemented, **measured to
regress**, and reverted. The two engines are not equivalent:

| Input | `Date.ISO8601FormatStyle` (kept) | `Date.ParseStrategy` (shared) |
| --- | --- | --- |
| `"2025-13-45"` | rejects → `nil` | **parses → 2026-02-14** |
| `"0000-00-00"` | rejects → `nil` | **parses → -0001-11-30** |

`Date.ParseStrategy` is lenient and rolls out-of-range components over.
`MediaListItem` swallows parse failures with `try?`, so sharing the strategy
would have converted a malformed date into a *plausible wrong one* instead of
`nil` — with no error surfaced and no test failing. Both already parse at GMT, so
the divergence costs nothing that this decision was trying to buy. Both files say
why it is there, and both halves of the asymmetry are pinned by tests.

### The proof mechanism

CI runners are UTC, so an assertion that a decode equals GMT midnight **passes on
the unfixed tree**. A white-box check (`formatter.timeZone == .gmt`) is equally
vacuous, and `TimeZone` equality compares identifiers, so `"UTC" != "GMT"` can
make it falsely red.

The proof therefore lives in CI, not in the assertions: `unit-test-timezones`
runs the unit suites under a **two-zone matrix**. Both legs are load-bearing and
they catch different tests:

- **`America/Los_Angeles` (−8)** catches the **outbound** formatter — a
  GMT-midnight instant formats as the *previous* day. Auckland cannot fail these.
- **`Pacific/Auckland` (+13)** catches **year-boundary maths** — `startOfYear`
  lands in the previous year. Los Angeles cannot fail these.
- Inbound and round-trip assertions fail at any non-GMT offset.

An in-process `NSTimeZone.default` swap was considered and rejected: it mutates
process-global state inside a parallel test runner, which this repo has already
been bitten by (see the `MockURLProtocol` entry in `gotchas.md`), and it degrades
silently — if it ever stopped working, every assertion would still read
`== <GMT value>` and pass.

## Consequences

- **A silent behavioural break.** 17 public day-precision `Date` properties shift
  by the consumer's local UTC offset with no compile error. Code that displayed a
  date correctly with `releaseDate.formatted()` now shows the previous day west
  of Greenwich — the library's own README and DocC examples had exactly this bug
  after the pin and were fixed with an explicit GMT format style. Persisted or
  cached values no longer compare equal to freshly decoded ones.
- **Callers' filter dates change meaning.** A `Date` passed to `startDate:` or
  `releaseDateMin:` is now read as its GMT calendar day.
- **The whole proof hangs on one CI job.** Delete `unit-test-timezones`, or trim
  it to a single zone, and a class of test silently stops proving anything. The
  job is registered in both the `ci` aggregate job's `needs:` list and its
  `results=( … )` array — a job in neither gates nothing — and the leg asymmetry
  is documented in the test file.
- **Two parse strategies remain**, and the duplication is intentional. A future
  "tidy this up" that shares them re-introduces silent data corruption; the
  characterisation tests exist to fail if anyone tries.
- `TMDbTesting`'s sample values were already GMT-midnight absolute instants, so
  they now agree exactly with what the decoder produces.

## Alternatives considered

- **Model calendar dates as calendar dates** (a `CalendarDate` type, or
  `DateComponents`). Semantically correct and the right long-term shape, but a
  much larger source break across 17 public properties. Declined outright rather
  than deferred — nothing is queued in `next-major.md`.
- **Status quo, documented.** Keep local-zone decoding and document it loudly.
  Rejected: it leaves the outbound wrong-calendar-day bug in place, which is a
  wrong-results defect rather than a representational one.
- **Pin the decoder only.** Rejected: half a fix. It leaves the query-parameter
  bug and breaks the test files that move in lockstep with the formatter.

## Related

- [ADR-0019](0019-decode-tolerance-policy.md) — the decode-tolerance policy that
  makes `MediaListItem`'s `try?` deliberate, and therefore makes the strategy
  divergence load-bearing rather than cosmetic.
