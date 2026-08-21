# ADR-0021: Three shapes for a growable public vocabulary

- **Status:** Accepted (in 20.0.0, unreleased)
- **Date:** 2026-08-13
- **Deciders:** Adam Young

## Context

`TMDbIntelligence`'s natural-language vocabulary is young and still growing, but
every public enum in it was a closed enum with no escape valve. This package ships
as source via SwiftPM — no library evolution, no `@frozen` — so from a consumer's
point of view **a public enum is already frozen**: adding a case breaks every
exhaustive `switch` downstream. Each new intent, curated list or degradation was
therefore a major-version event, permanently.

Two constraints shaped the fix:

1. **A catch-all case does not, on its own, prevent the break.** This was the
   central assumption of the originating review (issue #420) and it is wrong.
   Adding `case other(String)` to `SearchDegradation` does nothing to stop a later
   `case unresolvedNetwork(String)` from breaking exhaustive switches. A valve
   only works if *all* future growth is routed through it — the commitment, not
   the case, is the mechanism.
2. **[ADR-0019](0019-decode-tolerance-policy.md) limb 2's `.unknown` idiom does
   not transfer.** It calls `.unknown` "the existing codebase-wide idiom", but
   every instance exists because the value is **decoded from an untrusted wire
   payload** (`Status`, `ShowType`, `CreditType`, `Gender`, `TMDbStatusCode` —
   all `Codable`, all `init(from:) → ?? .unknown`). None of the
   `TMDbIntelligence` vocabularies are `Codable` or decoded from anything; they
   are constructed in-process by this module's own code. Their problem is
   *source* compatibility, not decode tolerance, so the two need different
   answers.

Also relevant: `NaturalLanguageSearchAvailability.Reason` mirrors Apple's
on-device model availability vocabulary, which grows with the OS, and its two
`@unknown default:` arms were mapping any Apple-added reason onto
`.modelNotReady` / `.unsupportedOS` — actively lying to a caller, who would wait
for a model download that was never pending.

## Decision

We will apply **one rule with three shapes**, chosen by how the value originates
and whether it carries a payload:

| The vocabulary is… | Shape | Examples |
| --- | --- | --- |
| decoded from the wire | enum + `.unknown` case, `init(from:) → ?? .unknown` | `Status`, `ShowType`, `CreditType` (ADR-0019 limb 2) |
| in-process, payload-free, growable | **extensible struct** | `SearchPlan.Intent`, `SearchPlan.ListKind`, `NaturalLanguageSearchAvailability.Reason` |
| in-process, payload-carrying, growable | enum + **reserved growth slot** | `SearchDegradation.other(String)` |

**The table has three rows, not four, and the missing fourth is deliberate.** A
*wire-decoded, payload-carrying* vocabulary looks like a gap in the grid, and it
is not one: that cell is a **media-type discriminator**, and
[ADR-0019](0019-decode-tolerance-policy.md) limb 1 already governs it — the
unmodelled value is skipped from its nearest enclosing tolerant array and
counted, never widened into a growth slot. This ADR covers limb-2 *value* enums
only. The distinction is easy to lose: while adding `TaggedImageMedia.tvSeries`
(#486) the plan claimed this fourth row was needed, and two of three plan
critics agreed before the limb boundary was re-read. If you find yourself
reaching for a new row here, check first whether what you have is a
discriminator.

The **extensible struct** is a public struct wrapping an `internal` backing enum:

```swift
public struct Intent: Sendable, Equatable, Hashable, CustomStringConvertible {
    enum Kind: Hashable { case find, browse, … }   // internal — see Consequences
    let kind: Kind                                  // internal
    private init(kind: Kind) { self.kind = kind }

    /// Look up a title or name directly.
    public static let find = Intent(kind: .find)
    …
}
```

The **reserved growth slot** is a terminal `case other(String)` carrying a stable
identifier, plus a written commitment: new kinds ship as `.other` in a **minor**
release and are promoted to cases of their own at the next major.

## Consequences

- **New members ship in a minor release without breaking anyone.** Construction
  (`SearchPlan(intent: .find)`), `==`, `if case .find = plan.intent` and a
  `switch` with a `default:` all keep compiling — implicit-member lookup resolves
  a static property exactly as it did an enum case, through `Optional`, array and
  variadic element types, ternaries and function returns alike. Only an
  *exhaustive* `switch` stops compiling, which is the point, and it is a one-time
  break taken inside the open 20.0.0 window.
- **Internal code keeps full compiler exhaustiveness.** This is why `Kind` is
  internal rather than a public `rawValue`: every internal dispatch switches on
  `x.kind` with no `default:`, so adding a `Kind` case still fails the build until
  every arm is handled. A `RawRepresentable` public struct would have forfeited
  that — and would have inherited the rawValue-equality trap recorded in
  `gotchas.md` for `TMDbStatusCode`.
- **`Kind` stays `internal`, never `package`.** `package` buys nothing here and
  costs the DocC-link ban (`gotchas.md` → *A `package` symbol cannot be referenced
  by a DocC link*). Never write `` ``Kind`` `` or `` ``kind`` `` in a doc comment.
- **`Hashable` and `CustomStringConvertible` are compatibility requirements, not
  polish.** A payload-free enum is implicitly `Hashable` and interpolates as its
  bare case name; a struct is neither. Both must be declared and both must be
  tested. See `gotchas.md` → *Converting a payload-free public enum to a struct
  silently drops two implicit conformances*.
- **`public init(kind:)` is impossible**, since the parameter type is internal —
  so a consumer physically cannot construct an out-of-vocabulary value. The
  externally-constructible value space is therefore *narrower* than the enum's,
  not wider.
- **Existing DocC links need no change.** `` ``Intent/byPerson`` `` resolves to a
  `public static let` with byte-identical syntax; `RetryableErrors` is the in-repo
  precedent. Verified against `make build-docs` under `--warnings-as-errors`
  before the bulk conversion, by converting `Reason` alone first.
- **`MediaType` and `RelativeDate` are deliberately excluded.** `MediaType` is
  bounded by this feature's *result surface* — `NaturalLanguageSearchResult`
  exposes exactly `movies`, `tvSeries` and `people` — not by TMDb's media taxonomy
  (core `Media` models four kinds including `.collection`). `RelativeDate` carries
  payloads the executor computes year bounds from, where a catch-all member would
  be uncomputable. Both are queued in [`../next-major.md`](../next-major.md) so
  the exclusion is revisited rather than forgotten.
- **The `plan(for:)` / `search(matching:)` asymmetry is intentional.** The related
  `NaturalLanguageSearchError.searchFailed(TMDbError)` arm added alongside this
  work exists only in `search(matching:)`. `plan(for:)` calls only the on-device
  planner and issues no TMDb request, so `.searchFailed` there would be a lie —
  nothing was searched — and `.planningFailed` remains correct.
- **Watch:** three shapes is two more than one. The table above is the whole
  point of this ADR — a contributor adding a vocabulary now has a rule to follow
  rather than three in-tree precedents to choose between.

## Alternatives considered

- **A catch-all case on every vocabulary** (the originating issue's proposal).
  Rejected as the general answer: it defers the break rather than removing it
  (see Context 1), and for a payload-free vocabulary it also turns a typed
  member into a stringly-typed one. Kept only where the struct shape cannot go —
  `SearchDegradation`, where 6 of 9 cases carry payloads that a struct would
  strand, breaking `if case .unresolvedGenre(let name)` binding with no clean
  equivalent.
- **A `RawRepresentable` struct with a `public let rawValue: String`.** More
  debuggable and forward-decodable, but it surrenders internal exhaustiveness
  checking — the compiler would no longer flag a missed arm when *we* add a
  member — and re-introduces rawValue equality semantics. The internal-`Kind`
  shape keeps both.
- **Leave the enums closed and take the break at each major.** Rejected: the
  vocabulary is expected to grow with planner capability, which would tie ordinary
  feature work to the major-version cadence indefinitely.
- **Convert `MediaType` too, for consistency.** Deferred rather than rejected —
  see Consequences and `next-major.md`.
