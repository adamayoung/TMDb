# ADR-0019: One decode-tolerance policy — skip an unmodelled media type, stay loud otherwise

- **Status:** Accepted
- **Date:** 2026-08-12
- **Deciders:** Adam Young

## Context

Decode tolerance had been patched in two opposite directions, and fixing either
half alone made the asymmetry worse.

**Too lenient.** `PageableListResult` — behind every pageable endpoint — and
`V4List` dropped *any* element that failed to decode, unbounded and unreported,
via a `FailableDecodable` wrapper that swallowed every error. That wrapper's own
documentation told callers to pair it with a count reconciliation; **no caller
did**. A genuine decoder regression therefore arrived as a quietly short page
with no signal at all.

**Too brittle.** `ShowType` had no `unknown` fallback, and `MediaList.items`,
`PersonCombinedCredits.cast`/`crew` and `PersonListItem.knownFor` used
all-or-nothing array decoding. One foreign `media_type` failed a whole response.

Three live bugs were sitting underneath, and each had been invisible for the
same reason — nothing reconciled what was decoded against what was sent:

- `lists.details(forList:)` and `lists.items(forList:)` threw for **any** list
  containing a TV series, because `MediaListItem` required the movie-shaped keys
  while TMDb sends `name`/`original_name`/`first_air_date` for a series.
- `tvSeries.details(appending: .lists)` had always returned an empty array:
  `TVSeriesDetailsResponse.lists` was typed `MediaPageableList`, but
  `/tv/{id}/lists` returns list summaries with no `media_type` key, so every row
  failed and was silently dropped.
- `PersonListItem.knownFor` could discard the **whole person** from a page.

A field/nullability sweep over ~7,900 live records found each of these. Its other
half mattered as much: it *cleared* every other required decode by measurement,
including `ProductionCompany.originCountry`, where the 9%-null figure recorded
for `/company/{id}` turns out not to transfer to `/search/company` at all.

## Decision

We will apply one policy, in three limbs:

1. An unmodelled **media-type discriminator** is skipped from its **nearest
   enclosing tolerant array**, and **counted** there.
2. An unmodelled value of a closed-vocabulary **value enum** (`Status`,
   `Gender`, `ShowType`, `CreditType`, …) decodes to `.unknown` — the existing
   codebase-wide idiom. No count; the value is usable as-is.
3. **Everything else throws.**

Mechanically:

- A single internal `UnknownMediaTypeError` is thrown by `decodeMediaType`, the
  one place that decides a `media_type` is unmodelled. It decodes the raw
  *string* first, so an absent key, a `null` and a non-string all still produce a
  genuine `DecodingError`. Decoding the enum with `try?` would have collapsed all
  four cases into "unmodelled" and silently reopened the unbounded tolerance this
  change exists to remove.
- `FailableDecodable` is replaced by `decodeSkippingUnknownMediaTypes` and an
  `…IfPresent` variant that preserves `nil` for an absent key, both catching only
  that sentinel.
- Five containers carry a `package droppedItemCount`: `PageableListResult`,
  `V4List`, `MediaList`, `PersonCombinedCredits` and `PersonListItem`.
- A discriminator with **no tolerant container above it** keeps throwing
  `DecodingError`, so `TMDbError.decode(_:)` still always carries one for
  consumers. `CreditMedia` is the one such site today and is deliberately
  untouched.
- `ShowType.unknown` is decode-only. It is rejected in `TMDbV4ListService` with
  `TMDbError.badRequest` — not in `ShowType.encode(to:)` (which would break
  `Codable` round-tripping of public models that legitimately hold `.unknown`,
  and report at the wrong altitude) and not in the `V4ListMediaItem` /
  `V4ListItemComment` initialisers (which would miss the decode path).

The two halves are **genuinely different decisions**, not one "be tolerant" rule.
Making an enum tolerant is additive, loses no information, and benefits from the
open 20.0.0 window. Bounding `PageableListResult`'s silent drops runs the
opposite way — it *surfaces* failures that are currently invisible, and gains
nothing from a major-version window. Limb 3 is what stops limb 1 from flattening
into "swallow anything".

## Consequences

- **Every pageable endpoint can now throw where it previously returned partial
  data.** That is the point, and it is bounded by the sweep rather than by hope:
  the live suite passes, and `TVSeriesListItem.originCountries` was softened as
  defence in depth even though it measured clean on all 1,046 sampled rows.
- **A caller still cannot detect a skipped element** — `droppedItemCount` is
  `package`, matching the issue's own framing of an internal count. The `V4List`
  note saying a skipped item is undetectable was therefore *reworded*, not
  deleted: it remains true outside the package. Making it `public` is purely
  additive and can be revisited.
- **The counts must be asserted or they are decoration.** They are, on the
  closed-vocabulary endpoints (lists, combined credits) — deliberately not on
  search or trending, where a genuinely new TMDb media type is plausible and
  would turn the weekly cron red for something working as designed.
- **One assumption is pinned by a test rather than by the type system:** that a
  non-`DecodingError` thrown from a nested `init(from:)` escapes `JSONDecoder`
  unwrapped. Verified on macOS; Linux uses a separate decoder, so a named canary
  test guards it. If it ever fails, throw `DecodingError.dataCorrupted` carrying
  the sentinel as its `underlyingError` and match on that instead.
- **`TaggedImageMedia` models only `movie` and `tv_episode`**, but 31 of 229
  sampled tagged images are `tv` — roughly 13.5% of every tagged-images page is
  discarded, and far more for TV-heavy people. That was previously invisible and
  is now counted. Modelling `tv` is a separate feature decision.

## Alternatives considered

- **A `DroppedItemCount` wrapper struct** whose `==` always returned `true`, so
  five structs could keep synthesized `Equatable`. Rejected once the count went
  `package`: no production code compares these models, so a plain `Int` in the
  synthesized `==` breaks nothing and avoids deliberately bending equality on
  public types.
- **A `MediaTypeDiscriminated` protocol** carrying a `Set` of modelled raw
  values, so the wrapper could check the discriminator without ever calling the
  element's `init(from:)` — deleting the sentinel and the Linux question
  entirely. Rejected: it duplicates each enum's vocabulary in a second place that
  can drift, and two independent reviewers verified the sentinel mechanism works
  on both platforms.
- **A `Decoder.userInfo` drop sink.** Rejected: needs a reference-type sink
  threaded through the serialiser, and is invisible to integration tests.
- **A new `TMDbError` case** for the media-type guard. Rejected:
  `knowledge/next-major.md` re-deferred the error-idiom question, and
  `.badRequest` with a `statusMessage` is the established in-repo shape.
- **New `name`/`firstAirDate` properties on `MediaListItem`** instead of mapping
  the TV keys onto the existing ones. Rejected: `CollectionListItem` already sets
  the precedent, and it would force every caller to branch on `mediaType`.
- **A throwing `ShowType.encode(to:)`.** Rejected — see Decision.
