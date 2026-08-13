# Next Major Version — Breaking-Change Backlog

Changes that are approved in principle but **breaking**, so they wait for a
major version bump. This file exists because deferred breaking changes
previously lived only in rejection logs and API notes, and nothing consulted
them at release time — they missed the 19.0.0 window as a result.

**Read this when:** you open a `[X.0.0]` section in `CHANGELOG.md` (the
sentinel comment there points here), or a plan already contains one breaking
change (batch deliberately, or record why not).
**Write to it** via `/capture-knowledge` whenever a fix is rejected or
deferred *because* it is breaking. **Remove an entry when it ships** (the
CHANGELOG records it) or is rejected outright (record that in
`skill-improvement-log.md`).

> **Status: the 20.0.0 window is OPEN.** The `Network.homepage` rename shipped
> into it (2026-08-07), and on 2026-08-12 issue #419 reopened `TMDbError` to add
> `.cancelled` — which finally met the deferred `invalidRating` entry's own
> condition. That entry was settled (rejected outright) and removed; see
> [ADR-0018](decisions/0018-cancellation-as-tmdberror-case.md) and the
> `skill-improvement-log.md` entry of the same date. Anything added here now is
> queued for **21.0.0** unless 20.0.0 is still untagged when you read this.
>
> **Still untagged as of 2026-08-13** (latest tag is `19.0.0`), so the two
> `TMDbIntelligence` vocabulary entries added that day are deferred by **scope
> choice, not by the window** — they were consciously left out of issue #420's
> delivery to keep its diff focused, and could still land in 20.0.0 if someone
> picks them up before the tag. Re-check with `git tag --sort=-v:refname` rather
> than trusting this line.
>
> **This file has earned its keep once.** It was written on 2026-07-27 and read
> on 2026-07-28, while 19.0.0 was assembled but still untagged — which is the
> only reason the `Company.logoPath` decode bug (#404) made that release instead
> of waiting for 20.0.0.

## Backlog

### Fix the remaining 54 defaulted-witness conveniences

- **What:** 54 public-extension conveniences still share a protocol
  requirement's signature, differing only by default argument values, so each
  *is* that requirement's default implementation — a third-party conformer that
  omits the requirement compiles and then recurses to a stack overflow. See
  `knowledge/gotchas.md` § *A protocol-extension convenience that differs only
  by a default argument becomes the requirement's witness*.
- **Why it waits:** these have **2–4** defaulted parameters, so the
  dropped-parameter fix used for the other 37 would need the *power set* of
  overloads (4, 8 or 16 per site) to keep every current call form compiling.
  The alternative — dropping the short forms outright — is source-breaking for
  ordinary callers, not just conformers, which is what makes it major-only.
  Distribution: 22 sites with 2 defaults, 30 with 3, 2 with 4.
- **Guard in the meantime:** `Scripts/check-defaulted-witnesses.py` runs both
  from `make lint` and as its own step in the CI `Lint` job. It fails if any
  single-default site appears, and it compares the multi-default sites against
  an explicit `DEFERRED` allowlist — an exact set, not a count, so a fix and a
  regression cannot cancel out and an empty scan cannot pass. **Deleting a
  site from that allowlist is part of fixing it**; at empty, delete the script
  and its two invocations.
- **Source:** 20.0.0 sweep (2026-08-07), which fixed the 37 cheap sites.

### Give `SearchPlan.RelativeDate` an open-ended bound

- **What:** `SearchPlanMapper.swift:94-98` collapses a lone upper bound — "movies
  up to 2010" — to `.exactYear(2010)`, because `RelativeDate` has no open-ended
  case. The prompt asks for a range and gets a single year, silently. The mapper's
  own comment records the gap.
- **Why it waits:** the fix is a new payload-carrying case (`upTo(Int)` /
  `from(Int)`, or generalising `between(start:end:)` to optional bounds) on a type
  that **stays an enum** by decision — [ADR-0021](decisions/0021-extensible-public-vocabularies.md)
  excludes `RelativeDate` from the extensible-struct shape because a catch-all
  member would be uncomputable for a constraint the executor must derive year
  bounds from. So the addition is source-breaking for exhaustive switchers with no
  valve available.
- **Note:** this is a *functional* gap, not an extensibility one. It was left out
  of issue #420 deliberately to keep that diff to the two things the issue asked
  for.
- **Source:** issue #420 delivery (2026-08-13).

### Convert `SearchPlan.MediaType` to an extensible struct — if the result surface grows

- **What:** `MediaType` (`movie` / `tv` / `person`) is the one payload-free
  vocabulary in `SearchPlan` left as a closed public enum after
  [ADR-0021](decisions/0021-extensible-public-vocabularies.md).
- **Why it waits — and the condition:** it is bounded by this feature's **result
  surface**, not by TMDb's media taxonomy. `NaturalLanguageSearchResult` exposes
  exactly `movies`, `tvSeries` and `people`, so a fourth media type could not be
  *returned* without a larger change than adding a member. **Convert it when, and
  only when, that result surface grows** — at which point the conversion is the
  smaller half of the work. (Beware the tempting wrong rationale: "TMDb has
  exactly three media types" is false — core `Media` models four including
  `.collection`, `TaggedImageMedia` adds `.tvEpisode`, and the package ships
  `CollectionService`. A reviewer caught that claim in #420's first draft.)
- **Source:** issue #420 delivery (2026-08-13), code review.
