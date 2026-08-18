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

Report the count adopted — a number that keeps growing means an issue-filing
skill is skipping its board step, which is a bug in that skill, not here.

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

**Skip the agent** when both hold:

1. the marker's `<sha>` equals the `origin/main` sha from Phase 1 — `main` has not
   moved, so no code under any issue can have changed; **and**
2. the issue itself has no update (body edit, new comment, label or title change)
   more recent than that marker's comment.

A skipped issue carries its marker's `exit`, `priority`, `size` and `deps`
forward, which is why the marker holds them rather than the digest alone — it
keeps its place in the ordering without an agent having read it.

Anything else is triaged: no marker, an unparseable one, a moved `main`, or a
touched issue. Prefer re-triaging on doubt — the cost of a needless agent is
tokens, the cost of a wrongly-skipped one is a stale verdict presented as current.

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
   something else can sit between them.
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
hostile.

## Rubrics

**Priority.** P0 — data loss, credential exposure, or blocks a currently-open
release. P1 — a correctness defect, or a latent break with a *scheduled* trigger
(some known future event fires it). P2 — hygiene, CI ergonomics, docs, and
latent breaks with no trigger.

**Size.** XS — one file, under an hour. S — one unit of work, obvious tests.
M — a model/decoder change with fixtures, or a mechanical port across files.
L — multi-item, or wants several PRs. XL — needs a plan before it can start;
say so, since XL and `split` usually travel together.
