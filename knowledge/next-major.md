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
> into it (2026-08-07) and the `TMDbError` item below was consciously
> re-deferred. Anything added here now is queued for **21.0.0** unless 20.0.0 is
> still untagged when you read this.
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

### Revisit `TMDbError.invalidRating` inside a broader `TMDbError` review

- **Re-deferred at 20.0.0 (2026-08-07), deliberately.** The window was open and
  this entry was read. It stays because its own condition is not met: it is only
  worth doing *inside* a wider `TMDbError` review, and 20.0.0 did not open one.
  Shipping the merge on its own would trade a precise typed case for a
  stringly-typed one with no compensating cleanup — the reason it was rejected
  in the first place. Recorded rather than skipped, so the next reader knows it
  was considered and not merely missed.

- **What:** the audit floated merging `.invalidRating` into `.badRequest` and
  rejected it as a net-worse API (a precise typed case traded for a
  stringly-typed one). If a major bump reopens `TMDbError` anyway, settle the
  argument-validation error idiom once, as part of that review — never as a
  standalone change.
- **Why it waits:** removing/merging a public enum case — breaking, and only
  worth doing inside a wider review.
- **Source:** `skill-improvement-log.md` → *Error-idiom unification*
  (rejected 2026-06-30).
