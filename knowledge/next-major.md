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

> **Status as of 2026-07-28: 19.0.0 is assembled but *not tagged*** — the
> newest tag is `18.2.0` while `CHANGELOG.md` already carries a `[19.0.0]`
> section. Everything below is therefore **still eligible for 19.0.0**, not
> deferred to 20.0.0. That call is the maintainer's; this note exists so it is
> made deliberately rather than by the window closing unnoticed a second time.
>
> **First use of this file worked:** the `Company.logoPath` fix shipped into the
> 19.0.0 window on 2026-07-28 because this queue was read, one day after it was
> written. Remove the status note once 19.0.0 is tagged.

## Backlog

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
