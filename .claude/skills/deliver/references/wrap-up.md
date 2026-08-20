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
- **`consulted:`** — Phase 0's knowledge-consult proof, copied from the run
  file: the `knowledge/` entries and ADRs read at entry, or `none relevant`.
- **`reconciled:`** — Phase 1's worktree sweep, e.g.
  `reconciled: 2 in scope / 1 reclaimed / 0 resumable / 1 reported / 0 claims
  released`. Named for the run file's own `reconciled` block. The last slot is
  `next`-specific — issues released from **In progress** because the run holding
  them died; it is `0` on almost every delivery, and a non-zero value is worth a
  sentence in the retro rather than just a number.
- **`swept:`** — Phase 7's knowledge-retirement sweep, verbatim from
  `/capture-knowledge`'s report line, e.g.
  `swept: Makefile, ci.yml → 1 entry rewritten`, or `swept: n/a`.
- **All three are tripwires. A missing line means that step did not run** —
  and the retro is where they bite, because it is committed and goes through
  PR review, so a human sees the omission. **This applies to entries written
  from 2026-08-13 on**, when the three keys were separated; earlier entries
  predate the rule and a missing line there says nothing about whether the step
  ran. Don't read the archive as a record of skipped phases. (`consulted:` and `reconciled:` also
  live in the run file, which is durable but never reviewed; `.git/` is not a
  diff.) **They are three separate keys on purpose:** when Phase 1 and Phase 7
  both wrote `swept:`, the Phase 7 form filled the slot for four consecutive
  deliveries and Phase 1's tripwire went missing without anyone noticing — a
  filled slot looks identical to the right one.
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

   **Then raise every unrecorded "one improvement", including singletons.** A
   *pattern* needs two entries to recur; a retro's **one improvement** needs
   none — it is already the single highest-value change that run identified.
   Scan the window's "one improvement" bullets and propose any with **no entry
   at all** in `skill-improvement-log.md` (not applied, not deferred, not
   rejected). It does not have to be *applied* — but it must reach a **recorded
   decision**, which is what the log is for. Without this step an improvement
   that never recurs is proposed by nobody: six went unrecorded this way.
3. **Stop and ask.** **Do not edit any skill files.** Present the proposals
   and wait for **explicit approval on each one**. If no *new* pattern recurs
   across multiple entries, say so and stop — emit no proposals.
   (**Auto:** **not delegable** — the panel has no Phase 11 decision point and
   the script throws if asked for one. Record every proposal in
   `skill-improvement-log.md` as `deferred — raised unattended, needs review`
   and apply none; an unattended run must never edit the repo's own skill
   files. See `references/auto-and-async.md`.)
4. **Record every decision in the log**, in the five-field format documented
   at the top of `skill-improvement-log.md` (date · title · status; Pattern /
   Decision / Rationale / Reconsider when) — **applied** (with the skill +
   commit), **deferred**, or **rejected**. The **Decision** and **Reconsider
   when** fields are what step 2's dedup keys on; keeping them on every entry
   is what stops the scan re-proposing a settled call.
