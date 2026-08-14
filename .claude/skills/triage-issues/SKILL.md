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

## Phase 1 — Resolve the board

Resolve by **title**, never by a hard-coded number — the number changes if the
board is recreated, and a stale number makes every later write a silent no-op:

```bash
gh project list --owner adamayoung --format json \
  | jq -r '.projects[] | select(.title == "TMDb") | .number'
```

Zero matches or more than one → **stop and say so**. Do not guess.

Capture `HEAD` (`git rev-parse --short HEAD`) and today's date; both are passed
to the workflow, which cannot compute a date itself.

## Phase 2 — Adopt orphans

Any **open** issue in `adamayoung/TMDb` that is not on the board is invisible to
this skill. Sweep them in before triaging, or a forgotten project assignment
silently loses work:

```bash
gh issue list --repo adamayoung/TMDb --state open --limit 200 --json number,url
```

Add each missing one; new items land in Backlog by default. Report the count
adopted — a number that keeps growing means an issue-filing skill is skipping
its board step, which is a bug in that skill, not here.

## Phase 3 — Fan out

Collect the Backlog issue numbers, then run the workflow:

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

## Phase 4 — Reconcile

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

## Phase 5 — Order

Sort the Ready set:

1. `dependsOn` order — a dependency always precedes its dependent.
2. Priority — P0, then P1, then P2.
3. Contention — do not schedule two file-contending issues adjacently when
   something else can sit between them.
4. Size ascending — smallest first inside a band, so the board drains.

Rule 1 outranks rule 2: a P2 that unblocks a P0 goes first. Say so explicitly in
the run-list when it happens, or it reads as a mis-sort.

## Phase 6 — Write

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

- End every triage comment with `<!-- triaged: <sha> | <evidenceDigest> -->`.
- Read the last such marker before writing. **Comment only if the
  `evidenceDigest` differs** from the previous run. A new `HEAD` alone is not a
  reason to comment; nothing changed for the reader.
- Field updates are always applied — they are idempotent and silent.

Comment content: what changed since filing, then corrected file:line pointers,
then anything a picker-upper needs that the body lacks. Do not restate the issue
back at its author.

## Phase 7 — Publish the run-list

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

## Phase 8 — Report

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
