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

## How to use it

- **Before solving a non-trivial problem**, skim the relevant file — the answer
  may already be here.
- **After learning something durable** (a gotcha, an API quirk, a decision),
  record it here in the same change — ideally via `/capture-knowledge`, which
  runs automatically before a PR in the `/deliver` pipeline.
- Keep entries **concise and dated**. Link related entries and ADRs.

## Relationship to other stores

This repo base is the **canonical, shareable** record (committed, reviewed in
PRs, travels with the code). It is complementary to — not a replacement for — any
personal/cross-project notes. Put durable, project-specific facts here.
