---
name: triage-issues
description: Review and assess every issue in the TMDb project board's Backlog column — re-verify each against current main with a read-only fan-out, close the mechanically dead, promote the actionable to Ready with priority, size and execution order, and leave the rest in Backlog naming the decision they need. Use to groom the backlog, before planning a release, or on a schedule. Runs headless: it decides for itself within the rules below.
---

# Triage Issues

Grooms the **Backlog** column of the `TMDb` GitHub Project into a queue someone
can work from without asking a question first.

The board is at `github.com/users/adamayoung/projects/<n>`; issues live in
`adamayoung/TMDb`. This skill **owns** the Ready test, the priority and size
rubrics, and the wontfix rules — nothing else in the repo restates them.
Issue *creation* is owned by [`.github/ISSUE_FILING.md`](../../../.github/ISSUE_FILING.md);
this skill consumes what that produces.

## Contract

**Input:** nothing. It discovers its own work.
**Output:** field updates on the board, at most one comment per changed issue, a
Project status update carrying the ordered run-list, and a summary to the caller.
**Never:** opens a PR, edits source, or changes an issue that is not in Backlog.

## Phase 1 — Resolve the board, and the tree

**Project operations go through the GitHub MCP** (`mcp__github__projects_*`), not
`gh project`. Per ADR-0009 the MCP is the default and `gh` covers only the
enumerated exceptions, which Projects is not — and concretely, `gh project`
requires a `read:project` token scope this repo's usual token does not carry, so
the `gh` route fails at the first call.

Resolve by **title**, never a hard-coded number — the number changes if the board
is recreated, and a stale number makes every later write a silent no-op:

```text
mcp__github__projects_list / list_projects   owner: adamayoung, owner_type: user
→ select the project whose title is exactly "TMDb"
```

Zero matches or more than one → **stop and say so**. Do not guess.

> **"Headless" here means unattended within a session — it decides for itself.**
> It cannot run on a GitHub Actions runner: the Project MCP is user-scoped and
> is not mounted there ([ADR-0009](../../../knowledge/decisions/0009-github-mcp-over-gh-cli.md)
> records this as the reason `claude.yml` and `integration-failure.yml` stay on
> `git`/`gh`), and `gh project` needs a scope this repo's token lacks. Wiring
> this to a cron would fail at the call above.

**Then pin the tree the verdicts are about.** The Ready test says "re-verified at
HEAD", which is worth nothing if HEAD is a stale checkout or a feature branch —
run this skill from an unfetched branch and every verdict is stamped against
history while claiming to be current.

```bash
git fetch origin
git rev-parse --abbrev-ref HEAD    # must be main
git rev-parse --short origin/main  # this is the sha passed to the workflow
```

Not on `main`, or `main` behind `origin/main` → say so and stop. The agents run
`git log` in this checkout, so the checkout has to be the thing being triaged.

> **A skill cannot be tested from the branch that introduces it.** This guard
> demands `main`, and checking out `main` removes an unmerged skill file — so
> the first real run necessarily comes after the merge. That is the right way
> round: a branch's tree is not what the issues are about. When this was first
> hit, `Sources/` and `Tests/` were identical to `main` but `ci.yml`, `Makefile`
> and `Scripts/` were not — which is exactly what two of the open CI issues
> were about. Dry-run the workflow directly if you need to exercise the
> machinery before merging; do not relax this.

Capture that sha and today's date; both are passed to the workflow, which cannot
compute a date itself.

## Phase 2 — Adopt orphans

Any **open** issue in `adamayoung/TMDb` that is not on the board is invisible to
this skill. Sweep them in before triaging, or a forgotten project assignment
silently loses work:

```bash
gh issue list --repo adamayoung/TMDb --state open --limit 200 --json number,url
```

Add each missing one with `projects_write / add_project_item`, then **set its
Status to Backlog explicitly** with `update_project_item`. Do not rely on the
board's "Item added" workflow to do it: whether that automation is enabled is not
queryable through the API and nothing here can check it. If it is off, adopted
items arrive with *no* Status — and since Phase 3 onward works from the Backlog
set and the
scope rule forbids touching anything outside Backlog, they would be permanently
invisible. That is the precise outcome this phase exists to prevent, so it must
not depend on an unverifiable assumption.

For the same reason, Phase 3 treats an item with **empty Status** as Backlog.

Report the count adopted. A growing count usually means an issue-filing skill is
skipping its board step — a bug in that skill, not here. **One standing
exception:** `.github/workflows/integration-failure.yml` files its alert issue
with plain `gh issue create` and cannot add it to the board, for the same reason
this skill cannot run on a runner. Those arrive as orphans every time. Adopt them,
but do not read them as a filing bug — and take care triaging one that tracks an
*in-flight* fix PR, since it is not stale, it is in progress.

## Phase 3 — Skip what cannot have changed

**Do this before fanning out, not after.** A triage agent costs roughly 80k
tokens, so a full backlog is over a million tokens a run. The comment-suppression
rule in Phase 7 saves *noise*; it does not save any of that, because the agent has
already run by the time the digest is compared. On a schedule, most runs would
spend a million tokens re-discovering that nothing moved.

For each Backlog issue, read the most recent triage marker in its comments:

```text
<!-- triaged: <sha> | <digest> | <exit> | <priority> | <size> | deps=<csv> -->
```

**Skip the agent** when all four hold:

1. the marker's `<sha>` matches the `origin/main` sha from Phase 1 — compare
   **by prefix**, either direction, since one may be short and the other full;
2. the issue's `updated_at` is no later than the marker comment's `updated_at`
   — that is the operational test, and it is why Phase 7 writes the marker
   comment **last**: any label or field write landing after it would stamp the
   issue as touched by this skill's own hand, and the item would re-triage
   forever;
3. the marker is **less than 30 days old**; and
4. the previous verdict's `verifiedBy` cites no live-API check, and its priority
   rests on no dated trigger (see below).

A skipped issue carries its marker's `exit`, `priority`, `size` and `deps`
forward, which is why the marker holds them rather than the digest alone — it
keeps its place in the ordering without an agent having read it.

**Conditions 3 and 4 exist because "`main` has not moved" is narrower than it
sounds.** A verdict rests on three things this repo does not control:

- **The live TMDb API.** Agents are told to re-check API claims with
  `mcp__tmdb__*` rather than trust the body. The API drifts on its own schedule;
  an issue can start or stop reproducing with `main` untouched.
- **The calendar.** P1 means "a latent break with a *scheduled* trigger". That
  trigger can fire between runs, turning a P1 into a P0 while nothing in the
  repo changed.
- **Dependencies closed elsewhere.** An issue blocked on another can become
  unblocked by that one being closed — including closed as `wontfix`, which is
  no commit at all.

The 30-day ceiling costs one full sweep a month and bounds all three.

Anything else is triaged: no marker, an unparseable one, a moved `main`, a
touched issue, an old marker, or a live-API/dated-trigger verdict. Prefer
re-triaging on doubt — the cost of a needless agent is tokens, the cost of a
wrongly-skipped one is a stale verdict presented as current.

Report the split (`n skipped, m triaged`). A run that skips everything is the
expected steady state, not a failure.

## Phase 4 — Fan out

Take the issues that survived Phase 3 — including any item whose Status is
**empty**, per Phase 2 — and run the workflow:

```text
Workflow({ scriptPath: '.claude/workflows/triage-issues.js',
           args: { issues: [437, 434, ...], head: '<sha>', today: '<YYYY-MM-DD>' } })
```

Pass `issues` as a **real array**, not a JSON string — a stringified array reaches
the script as one string and fans out per character. The script guards this, but
the guard is a backstop, not a licence.

One read-only agent per issue. They report; **only this skill writes**. That
separation is what keeps a parallel run from racing on the board.

If the workflow reports `untriaged`, those issues are **unknown**, not clean.
Leave them in Backlog untouched and name them in the summary.

## Phase 5 — Reconcile

The agents saw one issue each; the cross-issue judgements are yours.

- **Dependencies.** Build the `dependsOn` graph. A cycle means at least one edge
  is wrong — re-read both issues rather than picking one to break. An edge onto a
  **closed** issue is discharged; drop it.
- **Contention.** Two issues whose `filesTouched` overlap are not dependent, but
  landing them in parallel costs a rebase. Record it; it changes the order, not
  the status.
- **Ready demotion.** An issue is `ready` only if every issue it `dependsOn` is
  closed or also becoming Ready ahead of it. Otherwise it stays Backlog.
- **Duplicates.** Two `wontfix`/`duplicate` verdicts pointing at each other means
  neither agent saw the other. Keep the older issue, close the newer.

## Phase 6 — Order

Sort the Ready set:

1. `dependsOn` order — a dependency always precedes its dependent.
2. Priority — P0, then P1, then P2.
3. Contention — do not schedule two file-contending issues adjacently when
   something else can sit between them. This is computed only over **freshly
   triaged** issues: the marker carries no `filesTouched`, so a skipped issue
   contributes no contention edges. Say so in the run-list rather than implying
   full coverage.
4. Size ascending — smallest first inside a band, so the board drains.

Rule 1 outranks rule 2: a P2 that unblocks a P0 goes first. Say so explicitly in
the run-list when it happens, or it reads as a mis-sort.

## Phase 7 — Write

Per issue, by exit:

| Exit | Status | Also |
| --- | --- | --- |
| `ready` | **Ready** | set Priority + Size |
| `blocked` | stays **Backlog** | add `question` label; comment leads with the decision needed |
| `wontfix` | close as `not planned` | add `wontfix` label; comment states the basis and cites the evidence |
| `split` | stays **Backlog** | comment proposes the split; do **not** create the child issues |

Set Priority and Size on `blocked` and `split` items too — an unsized backlog
item cannot be planned around. Only `ready` moves column.

`split` deliberately stops at a recommendation. Fanning one issue into six
headless is a lot of tracker churn from a judgement call, and the split is
usually obvious to a human in ten seconds.

### Commenting — the idempotency rule

Headless on a schedule, a comment per issue per run makes the issues unreadable
within a month. So:

- End every triage comment with the verdict's `marker` field, **verbatim**. The
  workflow script assembles it so the written form and the form Phase 3 parses
  cannot drift apart. Do not hand-build it.
- Read the last such marker before writing. **Comment only if the
  `evidenceDigest` differs** from the previous run. A new `HEAD` alone is not a
  reason to comment; nothing changed for the reader.
- **When the digest is unchanged but `HEAD` has advanced, refresh the marker in
  place** — edit the existing triage comment so its `<sha>` is current, rather
  than posting a new one. Without this the marker's sha only ever advances when
  a *verdict* changes, so in the steady state this skill is built for — `main`
  moves, verdicts do not — Phase 3's skip could never fire and every run would
  pay the full fan-out. The comment body stays as it was; only the marker moves.
- **Write the marker comment last.** Labels and field updates first, comment
  after — see Phase 3 condition 2. A label written after the comment makes the
  issue look touched-since-triage on the next run, and it re-triages forever.
- Field updates are always applied — they are idempotent and silent.

The digest and the marker are computed **by the workflow script**, not by the
agent. The digest covers the decision-bearing fields only (`exit`, `priority`,
`size`, `wontfixBasis`, sorted `dependsOn`, sorted `staleClaims` locations).
Prose is deliberately excluded. Do
not ask an agent for it and do not recompute it here: an LLM asked for a "stable
fingerprint" will word the same findings differently each run, the digests will
differ every time, and this rule quietly becomes a no-op that still looks
enforced.

Comment content: what changed since filing, then corrected file:line pointers,
then anything a picker-upper needs that the body lacks. Do not restate the issue
back at its author.

## Phase 8 — Publish the run-list

One Project status update per run — this is where execution order lives, since
the board has no rank field:

```text
mcp__github__projects_write / create_project_status_update
  status: ON_TRACK (or AT_RISK if anything P0 is blocked)
```

Body: the ordered Ready list (number, title, priority, size, one-line reason),
then dependency edges, then contention warnings, then the Backlog-blocked items
each with its one-sentence decision. Keep it scannable — it is read at a glance,
and it is the diff between one run and the next.

### The run-list line — write it verbatim

End the body with **exactly this line**, and nothing else after it:

```text
<!-- run-list: <short sha> | <issue numbers, in order, comma-separated, no spaces> -->
```

`/deliver next` parses **this line and nothing else** to decide what to work on
([`.claude/skills/deliver/references/next-mode.md`](../deliver/references/next-mode.md)).
The prose table above it is for humans and is rewritten from scratch every run —
the 2026-08-18 and 2026-08-20 updates already use different column headers and
different cell formats, so anything parsing the table is parsing a moving target,
and a near-miss would silently discard the dependency and contention ordering
this phase exists to publish.

So: **assemble the line mechanically** — join the ordered issue numbers with
commas — and do not reword, prettify, annotate or wrap it. It is the same
discipline as the per-issue marker, for the same reason (an LLM re-authoring a
fixed format from prose produces a different string each time), with the same
consequence if it drifts: a consumer that quietly falls back rather than failing
loudly. A status update **without** this line is *not a usable run-list*, and
`next` will say so and fall back to board fields — which reproduces two of this
phase's four sort rules and loses the other two.

> The line is currently written by this skill, not built by
> [`.claude/workflows/triage-issues.js`](../../workflows/triage-issues.js) the
> way the marker is, because the ordering is decided in Phase 6 — after the
> script has returned. Moving Phase 6's sort into the script would close that
> gap; it is tracked, not done.

Mark `AT_RISK` when a P0 sits in `blocked`: the highest-priority work being
un-startable is exactly the state a status colour exists to surface.

## Phase 9 — Report

To the caller: counts by exit, the ordered Ready list, every `blocked` item with
its decision, anything closed and why, adopted orphans, and any `untriaged`
issues. If nothing changed since the last run, say that plainly rather than
padding — a quiet run is a good outcome, not a failed one.

## Rules that do not bend

**The Ready test.** All four, every time: claims re-verified at HEAD; fix
approach determined; no unmerged dependency; line references refreshed. A P0
that needs a decision is `blocked`. Priority never overrides the test — shipping
someone into an unmade decision is worse than leaving it visible.

**Wontfix is mechanical.** `no-longer-reproduces`, `superseded`, `duplicate`.
Nothing else. "Not worth doing" is a judgement a human takes; route it to
`blocked` with the case made. A wrongly-ready issue costs twenty minutes; a
wrongly-closed one is gone and nothing catches it.

**Verify, do not trust.** These issue bodies are written against older trees.
Line numbers rot, whole mechanisms get replaced, ADRs land that decide the open
question. An agent that reports without opening a file has not triaged anything —
that is what `verifiedBy` is for, and "read the issue body" forces `blocked`.

**Scope.** Backlog only, plus the orphan sweep. Never touch In progress, In
review or Done; someone is working there and a status change under them is
hostile. Those three columns have owners of their own — `/deliver` sets In
progress, `/watch-pr` sets In review, and the board's own automation sets Done;
the whole lifecycle is tabulated in
[`.github/ISSUE_FILING.md`](../../../.github/ISSUE_FILING.md) → *Board status —
the column lifecycle*.

## Rubrics

**The rubrics live in `.claude/workflows/triage-issues.js` (`RUBRIC`)** — that is
the copy handed to every agent, so it is the one that actually reaches a
decision. Read it there; do not restate it here. A second copy in this file
drifted from the script within a day of being written, which is precisely the
decay this repo's single-ownership rule exists to prevent.

What this skill owns and states above, because no agent needs it: the Ready
test's four conditions, the wontfix bases, the four exits, and the skip rule.
