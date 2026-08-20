# /deliver — `next` mode: selecting the work (reference)

Read on demand when `/deliver next` is invoked. `SKILL.md` Phase 0 summarises
this; the procedure, the exclusions and the traps live here.

`next` answers one question — *which issue should this delivery deliver?* — and
then hands a plan to the pipeline that already exists. Everything after the
plan is unchanged: Phase 0's entry gate, the worktree, the reviews, the gate.

**Requires the user-scoped GitHub Projects MCP.** Every step below is
`mcp__github__projects_*`, which is **not mounted on a GitHub Actions runner**
and cannot be replaced by `gh project` — the repo's token lacks the
`read:project` scope, so the `gh` route fails at the first call
([ADR-0009](../../../../knowledge/decisions/0009-github-mcp-over-gh-cli.md);
`/triage-issues` records the same constraint for the same reads). No
`projects_*` → **stop and say exactly that**. Never degrade into Phase 0's
"no plan" stop, which reads as an unrelated failure, and never fall back to
`gh project`.

## 1 — Resolve the board

```text
mcp__github__projects_list / list_projects   owner: adamayoung, owner_type: user
→ select the project whose title is exactly "TMDb"
```

Resolve **by title, never a hard-coded number**. Zero matches or more than one
→ stop. A hard-coded number fails quietly against the wrong board rather than
loudly against none.

## 2 — Build the live Ready set

```text
mcp__github__projects_list / list_project_items
  project_number: <resolved>   field_names: ["Status", "Priority", "Size"]
  per_page: 50                 — paginate until pageInfo.hasNextPage is false
```

Keep an item only if **both** hold: its `Status` is `Ready`, **and** its issue
`state` is `open`. Both halves are load-bearing — a closed issue can sit in
`Ready` for as long as it takes the board's automation to move it, and on
2026-08-20 the newest run-list was headed by an issue that was already `Done`.

Then remove three classes of candidate. Each is cheap, and each prevents a
distinct way of delivering the same work twice:

- **Already claimed by a PR** — an open pull request whose body carries
  `Closes #NNN` for that issue. One `mcp__github__list_pull_requests` call
  (`state: open`), which Phase 1's reconcile sweep already makes.
- **Already claimed by a live worktree** — a run file under `.git/deliver/`
  whose deliverable names that `issue` and whose worktree is `live` (lock PID
  alive; see [`worktree-lifecycle.md`](worktree-lifecycle.md)).
- **Breaking, in `merge` mode only** — see §5.

An empty set after filtering → **stop before any worktree**, report the counts,
and recommend `/triage-issues`.

## 3 — Order the candidates

The board has **no rank field**, so ordering lives in the Project status update
`/triage-issues` publishes. Read it:

```text
mcp__github__projects_list / list_project_status_updates   per_page: 5
```

Take the newest update carrying the canonical run-list line. That line has a
**fixed grammar**, defined once in `/triage-issues` (its Phase 8) and parsed
here and nowhere else:

```text
<!-- run-list: <sha> | 426,437,448,428,454,424,425,427,429,435,467,430 -->
```

Parse **only that line**. Its prose table is for humans and is written afresh
each run — the 2026-08-18 and 2026-08-20 updates already use different table
shapes, so a regex over the table is not reproducible, and a near-miss would
silently discard exactly the dependency and contention ordering the run-list
exists to carry.

**No status update carries the line → there is no usable run-list.** Say so, in
those words, and fall back to board fields: order by Priority (P0 → P1 → P2),
then Size ascending (XS < S < M < L < XL). State in the report that **dependency
and contention order are unknown on this path** — the fallback reproduces two of
`/triage-issues`' four sort rules, not all four. Never quietly best-effort the
prose table into a third ordering authority.

Final order:

1. Run-list entries that survived §2, **in run-list order**. That order already
   encodes dependency-first sorting, in which a P2 that unblocks a P0 legitimately
   precedes P0s — so never re-sort it by priority.
2. Any surviving item **absent** from the run-list, appended **last**, each
   flagged *"not in the current run-list — order unknown; `/triage-issues` owns
   it"*. Filing puts new issues in **Backlog**, and only `/triage-issues` writes
   `Ready` (and republishes the list with it), so this case means someone moved
   an item by hand. Appending is deliberate: an unordered item must not be
   interleaved into an order it was never sorted against.

Record the ordering source in the run file's `selection` block — either
`run-list@<sha>` or `board-fields (no run-list line; deps/contention unknown)`.

## 4 — Re-verify the head candidate

`Ready` means the issue passed `/triage-issues`' Ready test **at some sha**, not
at the current one. The 2026-08-20 run-list says so itself: 11 of its 13 entries
"were not re-verified". So re-verify before planning.

**Pin the tree first.** Fetch, then resolve the ref:

```bash
git fetch origin
git rev-parse --short origin/main
```

Verify against **`origin/main`**, not against `HEAD`. `/deliver next` may be
invoked from a worktree or any feature branch — `CLAUDE.md` makes a non-`main`
checkout the normal case — so a verifier told to read "HEAD" grades a tree that
is not the one being delivered against, while claiming to be current. Pin the
**ref**, not the checkout: hand the resolved sha to the verifier and have it
read `git show origin/main:<path>` and `git log origin/main`. Record it as
`verifiedAt` in the `selection` block.

Spawn **one read-only subagent per candidate**, given the issue body, its latest
`<!-- triaged: … -->` marker comment, and that sha. It returns:

| Verdict | Meaning |
| --- | --- |
| `startable` | every claim in the body still holds at the sha; the fix approach is determined; no unsatisfied `dependsOn` |
| `stale` | a load-bearing claim no longer holds — the code moved, or it was already fixed |
| `needs-decision` | sound, but the fix approach is not determined (a `**Decision needed:**` line, a `question` label, or an open `dependsOn` from the marker's `deps=`) |

plus the **one deciding fact** and **what it checked first-hand**. A verifier
that cannot name what it checked votes `stale`.

**A dead verifier is not a `startable`.** Retry once; still dead or unusable →
the candidate is **rejected**, and the run moves on. This is deterministic on
purpose — "fall back to deciding it yourself" would hand the startability call
to the party with an interest in continuing, which is the whole reason the
dead-grader rule exists in Phase 6.

**`dependsOn` outranks priority.** An open dependency makes a candidate
`needs-decision` even when it sits at the head — `/triage-issues` Phase 6 sorts
dependencies first, and its `deps=` marker field is where that fact survives for
an issue no agent re-read this run.

### Rejecting a candidate

A rejected candidate is **moved to `Backlog`**, with a comment naming what no
longer holds. Both halves matter:

- **The move is what gives it an exit.** `/triage-issues` is scoped to Backlog
  and never re-examines a `Ready` item, so leaving it in `Ready` would mean the
  same poisoned head is re-verified, re-rejected and re-commented on every future
  run, while the items behind it stay unreachable. `/deliver next` **owns the
  `Ready` → `Backlog` transition** — recorded in
  [`.github/ISSUE_FILING.md`](../../../../.github/ISSUE_FILING.md)'s lifecycle
  table, so the column still has exactly one owner per transition. Leave
  `Priority` and `Size` untouched: they are `/triage-issues`' output and the
  verdict does not re-size anything.
- **The comment ends with a marker**, so it is idempotent and so triage picks
  the issue up next run:

  ```text
  <!-- deliver-next: rejected <sha> | <verdict> -->
  ```

  Read the last `deliver-next:` marker first and skip the comment when the
  verdict and sha are unchanged. The comment deliberately lands *after* triage's
  own marker, which makes the issue look touched-since-triage and forces a full
  re-triage next run — here that is the **point**, not a cost.

**Cap the rejects per run, not from the head.** Stop when either the whole
candidate list is exhausted or **5** candidates have been rejected in this run.
A "3 consecutive rejects" rule counted from the head would let three stale items
brick `next` permanently while startable work sat at position 4. Report
`n rejected, picked #m` in one line either way.

Nothing startable → **stop before any worktree**, list what was rejected and
why, and recommend `/triage-issues`.

## 5 — `merge` mode refuses a breaking change

`/deliver auto merge next` is the only invocation that can take an issue from a
board to a merged commit with nobody looking. Every issue body carries a
`**Breaking class:** none | source-breaking | behavioural | needs a decision`
line ([`.github/ISSUE_FILING.md`](../../../../.github/ISSUE_FILING.md)).

**In `merge` mode, a candidate is selectable only if its class is `none`.**
Absent or unparseable counts as `needs a decision`, never as `none`. Skip the
rest, name them in the report, and take the next candidate.

This is not belt-and-braces: `auto-and-async.md` already states that this is a
single-maintainer package with public API surface *"where the ready-to-merge
human gate is deliberate — every change is a compatibility call worth a human's
eyes"*. Without the filter, `/deliver auto merge next` would have squash-merged
a milestone-20.0.0 behavioural change on the day it shipped. Without `merge`,
`/deliver auto next` still delivers those issues — it just stops at the gate,
which is exactly where a compatibility call belongs.

## 6 — Claim the issue, then draft

**Claim before drafting.** The moment a candidate is `startable`, write
`Status = In progress` (call:
[`.github/ISSUE_FILING.md`](../../../../.github/ISSUE_FILING.md) → *Board status*),
then **re-read the item to confirm the write landed**. Only then draft.

Claiming here rather than at Phase 1 is deliberate. Phase 1 is the normal owner
of that move, and for a plan the user brought it is the right moment — the entry
gate can still stop the run. But `next` inserts a long window between the pick
and Phase 1: a `Plan` agent invocation and, attended, an unbounded wait for a
human. Concurrent `/deliver` sessions are explicitly sanctioned, so an unclaimed
pick is two deliveries of one issue. Phase 1's write then finds the item already
`In progress` and is a no-op.

**A claim must be releasable.** Nothing else in the repo moves an issue *out* of
`In progress`, so on **any stop before the PR opens** — a rejected plan, a
`/review-plan` blocker, a red gate, a panel `stop` — move the issue back to
`Ready` (Priority and Size untouched) and say so in the stop report. Skipping
this drains the queue into a column `next` can never see again and
`/triage-issues` is forbidden to touch. `/deliver` owns this reverse transition;
it is in the lifecycle table with the others.

**Draft with the `Plan` agent**, given the issue body, the verifier's findings,
and the `knowledge/` entries Phase 0's consult surfaced. From the issue:

- **The rubric.** The issue's *Failure scenario* section is already
  observable before/after behaviour — derive the ACs from it in
  "Given X, when Y, then Z" form. Record
  `rubricProvenance: derived — issue <number>`, **never `supplied`**, even
  though the drafted plan text carries ACs: `supplied` means a human set the
  bar, and here the same run that will be graded wrote them. Drop
  knowledge-shaped ACs exactly as Phase 0's entry gate requires.
- **The branch prefix** — `bug` → `fix/`, `enhancement` → `feature/`,
  `documentation` → `docs/`, anything else → `chore/`.
- **`issue: <number>`** on the deliverable in the run file.

## 7 — Approve, then continue

- **Attended** (`/deliver next`) → present the plan, its derived ACs, and one
  line on why this issue was picked, and **stop for approval**. Invoking
  `/deliver` is plan approval for a plan the user wrote; it cannot be approval
  for one that did not exist at invocation. This is the only pause `next` adds,
  and Contract §1 names it.
- **Auto** (`/deliver auto next`) → no stop. The decision is put to the
  **`phase0n-selection` panel** — three independent jurors ruling on whether to
  proceed with a machine-drafted plan for a machine-picked issue. Auto mode's
  invariant is that every stop-and-ask becomes a panel; dropping the stop
  silently would leave the conductor that chose the issue *and* wrote the plan
  as its own only judge. Procedure:
  [`auto-and-async.md`](auto-and-async.md).

Then continue through the rest of Phase 0 unchanged. A plan now exists, so
nothing downstream is special-cased.

## The `selection` block

Written into the run file at the end of selection, and **read by Phase 6**: a
run whose run file records `mode: next` with `selection` missing or empty
**hard-stops at the exit gate**, exactly as a missing `reconciled` block does.
Without that, `selection` would be telemetry nobody checks — a green
indistinguishable from never having run.

```json
"mode": "next",
"selection": {
  "source": "run-list@cc7cba55",
  "verifiedAt": "527682f7",
  "listed": 12,
  "picked": 426,
  "breakingClass": "behavioural",
  "rejected": [
    { "issue": 434, "verdict": "stale", "why": "closed by PR #469; filtered before verification" }
  ]
}
```
