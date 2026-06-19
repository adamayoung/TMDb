# Engineering Knowledge Base

Durable, project-specific knowledge for the TMDb Swift package — the things worth
remembering between tasks so they don't have to be re-learned or re-discovered.
This is **reference** material (why/what/gotcha), distinct from `CLAUDE.md`, which
is **imperative** (how to work here). `CLAUDE.md` carries only a thin index into
this directory; the detail lives here and is read on demand.

## What goes where

| File | Contents |
| --- | --- |
| [`decisions/`](decisions/) | **ADRs** — Architecture Decision Records, one per decision, numbered + dated. Use for any non-obvious design choice and its rationale. |
| [`gotchas.md`](gotchas.md) | Implementation quirks, things that bit us, tooling traps, and anything that needed a web search / lookup to resolve. |
| [`tmdb-api-notes.md`](tmdb-api-notes.md) | Behaviours of the **live TMDb API** discovered while implementing (nullable/absent fields, undocumented quirks, response-shape surprises). |
| [`delivery-retros.md`](delivery-retros.md) | A short retrospective per feature delivered via `/deliver` (its Phase 6) — what worked, friction, deviations, one improvement. |
| [`skill-improvement-log.md`](skill-improvement-log.md) | Decisions on every skill-improvement proposal from `/deliver`'s Phase 6 recurring-pattern scan (applied / deferred / rejected), so the scan doesn't re-propose settled calls. |

## How to use it

- **Before solving a non-trivial problem**, skim the relevant file — the answer
  may already be here.
- **After learning something durable** (a gotcha, an API quirk, a decision),
  record it here in the same change — ideally via `/capture-knowledge`, which
  runs automatically before a PR in the `/deliver` pipeline.
- Keep entries **concise and dated**. Link related entries and ADRs.

## Maintenance & retention

The base is a **cache of currently-true facts, not an archive** — git history is
the archive. Keep it lean so a reader (or agent) finds the signal fast. The files
age differently:

- **Append-only logs** (`delivery-retros.md`, `skill-improvement-log.md`) grow one
  entry per delivery/scan, so cap them with a **rolling window**:
  - Keep roughly the **last ~12 entries** in full prose.
  - Distil older ones into a compact one-line archive table
    (`date · PR · weight · one-line outcome`) and drop the prose — the telemetry
    (which skills fired, where deliveries stopped) survives; the bulk doesn't.
  - A retro entry's job is to feed the Phase 6 recurring-pattern scan; once its
    lesson is folded into a skill and recorded `applied` in
    `skill-improvement-log.md`, the prose is spent. The scan need only read the
    recent window plus the log — not the full history.
- **Curated reference** (`gotchas.md`, `tmdb-api-notes.md`) should *plateau*, not
  grow forever. **Retire entries that are no longer true:** when an upstream bug is
  fixed, a pinned version is lifted, the code is removed, or a quirk no longer
  reproduces, **delete** the entry (git preserves it). Describe the present, not
  the past.
- **ADRs** (`decisions/`) are one immutable file per decision — don't edit an
  Accepted ADR; **supersede** it with a new one that links back. This already
  scales; no window needed.
- **Don't pre-split a file.** Split a section into its own file only when it
  genuinely dominates (e.g. `gotchas.md` → `gotchas/tooling.md`), mirroring the
  project's "promote a boundary only when the pain shows up" rule. The dated `###`
  headings (newest at top) are the index — keep them grep-friendly so a reader can
  pull one entry without reading the whole file.

## Relationship to other stores

This repo base is the **canonical, shareable** record (committed, reviewed in
PRs, travels with the code). It is complementary to — not a replacement for — any
personal/cross-project notes. Put durable, project-specific facts here.
