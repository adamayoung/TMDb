# /deliver — retrospective & wrap-up (reference)

Read on demand from `/deliver` **Phase 8** (retro, pre-PR) and **Phase 11**
(wrap-up). The sequencing rules live in `SKILL.md`; this file holds the entry
format, the wiki guidance, and the recurring-pattern-scan procedure.

## Retro entry format (Phase 8)

A dated entry in `knowledge/delivery-retros.md`, newest at the top — a log,
not a ceremony (a handful of bullets):

- **Feature / branch**, date, and delivery weight (lite/full). The PR number
  doesn't exist yet — head the entry with the branch name; Phase 9 backfills
  the number right after the PR is created.
- **Phases completed / Skills invoked** — a compact one-liner each (e.g.
  phases `0–9`; skills `review-plan, implement-plan, review-changes,
  security-review, capture-knowledge`). Telemetry for the recurring-pattern
  scan: which skills fire, which phases get skipped, where deliveries stop.
- **What worked** — one or two things the pipeline did well.
- **Friction** — where it was rough, slow, or stopped unnecessarily.
- **Deviations** — anywhere you had to depart from the skill to do the right
  thing (a strong signal the skill has a gap).
- **One improvement** — the single highest-value change to `/deliver` (or a
  sub-skill) suggested by this run.
- **`watch:`** — omit at write time. Added only as a post-gate amendment for
  a noteworthy Phase 10 event; an uneventful watch adds nothing.

**Windowing.** After adding the entry, if `delivery-retros.md` holds more than
**~12 full entries**, distil the oldest into the one-line archive table
(`date · PR · weight · one-line outcome`) and drop the prose — per
`knowledge/README.md` → *Maintenance & retention*. An old retro's lesson
already lives in the skills and `skill-improvement-log.md`; the table
preserves the telemetry without the bulk.

## Why the retro is pre-PR

Every push to the PR branch re-triggers `claude-review` and the CI matrix.
When the retro was a routine post-gate push, every delivery paid a re-review +
re-run + re-watch for a markdown file — and on #361 the post-gate push raised
a High thread that blocked the merge. Writing the retro pre-PR (decision
recorded 2026-07-05 in `skill-improvement-log.md`) makes the default post-gate
push count **zero**; the re-watch rule survives only for the exceptions (a
`watch:` amendment, an approved skill edit from the scan).

## Update the personal wiki (Phase 11)

The retro distils this delivery's durable learnings, so wrap-up is the moment
to feed the **personal `wiki`** (Adam's cross-project engineering knowledge,
via the `wiki` MCP). The `knowledge/` base is *project-specific*; the wiki is
for **generalizable** opinions, heuristics, and patterns that would apply on
the next project too.

- **Degrade silently if the `wiki` MCP is absent** (a contributor's machine,
  a headless/cron run) — never block on it.
- **Search first** (`search_entries`) and prefer **updating** a near-match
  over creating a duplicate.
- **Propose, don't autonomously save.** Use **`propose_entry`** to render
  each candidate for review; `add_entry`/`update_entry` only on Adam's
  explicit approval. Cite the wiki when an answer later draws on it.
- **Be selective** — one or two high-signal entries beat a dump; skip
  anything project-specific (that lives in `knowledge/`) or already present.
  Capturing nothing is a valid outcome.

## Recurring-pattern scan (Phase 11)

The loop that turns one-off retros into reviewed skill improvements:

1. **Read the recent window + the log.** The **~last 12** entries of
   `knowledge/delivery-retros.md` (older ones are archived one-liners, so
   this is the whole live history), **all** of
   `knowledge/skill-improvement-log.md`, and **every** `SKILL.md` under
   `.claude/skills/`. The bounded retro read keeps the scan's cost flat as
   history grows.
2. **Find what recurs.** For any friction, deviation, or improvement
   suggestion appearing in **more than one** retro entry, write a numbered
   proposal in this exact format:

   ```text
   Pattern: [what keeps happening]
   Seen in: [retro dates / feature names]
   Skill: [relative path to SKILL.md]
   Current text: [exact existing wording, or "missing"]
   Proposed change: [exact new wording and location]
   Rationale: [one sentence on why this eliminates the pattern]
   ```

   **Skip any pattern already decided in `skill-improvement-log.md`** — one
   already **applied**, or **deferred/rejected** (don't re-propose a settled
   *no*; only resurface it if its recorded "reconsider when…" condition now
   holds).
3. **Stop and ask.** **Do not edit any skill files.** Present the proposals
   and wait for **explicit approval on each one**. If no *new* pattern recurs
   across multiple entries, say so and stop — emit no proposals.
   (**Auto:** the panel reviews each proposal instead — see
   `references/auto-and-async.md`.)
4. **Record every decision in the log**, in the five-field format documented
   at the top of `skill-improvement-log.md` (date · title · status; Pattern /
   Decision / Rationale / Reconsider when) — **applied** (with the skill +
   commit), **deferred**, or **rejected**. The **Decision** and **Reconsider
   when** fields are what step 2's dedup keys on; keeping them on every entry
   is what stops the scan re-proposing a settled call.
