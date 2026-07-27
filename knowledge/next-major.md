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
> newest tag is `18.2.0` while `CHANGELOG.md` already carries a
> `[19.0.0] - 2026-07-24` section. Everything below is therefore **still
> eligible for 19.0.0**, not deferred to 20.0.0. That call is the
> maintainer's; this note exists so it is made deliberately rather than by
> the window closing unnoticed a second time.

## Backlog

### Make `Company.logoPath` optional (`URL?`)

- **What:** `Company.logoPath` is `public let logoPath: URL` with a required
  decode (`Sources/TMDb/Domain/Models/Company.swift:45,126`), so an absent,
  `null`, or empty `logo_path` makes the **whole `Company` decode throw**.
  TMDb does return logo-less production companies — a live decode-failure
  risk, not a theoretical one. Fix: `URL?` with a guarded decode, matching
  `Network.logoPath`. Note the asymmetry in the same decoder: `homepageURL`
  *is* guarded (empty string → `nil`); only `logoPath` is unguarded.
- **Why it waits:** property type + `init` parameter change — breaking.
- **Source:** `tmdb-api-notes.md` → *`Company.logoPath` is a required decode*
  (2026-06-30); `skill-improvement-log.md` → *Align `Network` to `Company`*
  (rejected 2026-06-30).

### Align the `Company`/`Network` model shapes deliberately

- **What:** decide the canonical shape for the shared homepage-URL /
  logo-path fields and apply it to both models (including whether
  `Network.homepage` takes the `homepageURL` name). Do this together with the
  `logoPath` change above — the 2026-06-30 audit rejected aligning them in
  the *wrong* (non-optional) direction; the right direction is breaking.
- **Why it waits:** public property renames — breaking.
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
