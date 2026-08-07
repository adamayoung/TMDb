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

> **This file has earned its keep once.** It was written on 2026-07-27 and read
> on 2026-07-28, while 19.0.0 was assembled but still untagged — which is the
> only reason the `Company.logoPath` decode bug (#404) made that release instead
> of waiting for 20.0.0. The next window is **20.0.0**; everything below is
> queued for it.

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
- **Guard in the meantime:** `Scripts/check-defaulted-witnesses.py`
  (`make lint`) fails if any single-default site appears, or if the
  multi-default count exceeds 54. Lower `EXPECTED_MULTI_DEFAULT` as they are
  fixed; delete the script at zero.
- **Source:** 20.0.0 sweep (2026-08-07), which fixed the 37 cheap sites.

### Align the `Company`/`Network` model shapes deliberately — *partially shipped*

- **Shipped in 19.0.0 (2026-07-28):** the *nullability* half. `Company.logoPath`
  → `URL?`, `Company.originCountry` → `String?`, `Company.Parent.logoPath` →
  `URL?`, bringing `Company` into line with `Network`'s optionality. This also
  closed the separate "Make `Company.logoPath` optional" entry, which is
  removed. Plan review caught that `originCountry` throws on exactly the same
  records, so shipping `logoPath` alone would not have fixed the bug.
- **Consciously re-deferred:** the *naming* half — renaming `Network.homepage`
  to `homepageURL` for parity with `Company.homepageURL`. Deliberately left out
  of 19.0.0: it is a pure rename with no correctness benefit, and bundling it
  would have widened a bug-fix PR into a cosmetic breaking change. It buys
  nothing that waiting does not.
- **Why it still waits:** public property rename — breaking.
- **Source:** `skill-improvement-log.md` → *Align `Network` to `Company`*
  (rejected 2026-06-30; "Reconsider when: a major-version bump…").

### Revisit `TMDbError.invalidRating` inside a broader `TMDbError` review

- **What:** the audit floated merging `.invalidRating` into `.badRequest` and
  rejected it as a net-worse API (a precise typed case traded for a
  stringly-typed one). If a major bump reopens `TMDbError` anyway, settle the
  argument-validation error idiom once, as part of that review — never as a
  standalone change.
- **Why it waits:** removing/merging a public enum case — breaking, and only
  worth doing inside a wider review.
- **Source:** `skill-improvement-log.md` → *Error-idiom unification*
  (rejected 2026-06-30).
