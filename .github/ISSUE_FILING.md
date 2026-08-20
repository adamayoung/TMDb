# Filing a GitHub Issue

The single source of truth for **how work gets filed** in this repo. Skills that
discover work they are not going to do — `/review-changes`, `/deliver`,
`/capture-knowledge`, `/review-knowledge`, `/review-pr-threads` — point here
rather than restating any of it. `/triage-issues` consumes what this produces.

If this file and a skill ever disagree, **this file is right**.

## When to file

File when all three hold:

1. The work is **real** — a defect, a gap, or a decision that has to be made.
2. It is **out of scope for what you are doing now** — in scope means fix it,
   not file it.
3. It will be **lost otherwise** — it is not already captured in `knowledge/`,
   an ADR, `next-major.md`, or an open issue.

Do **not** file: anything you just fixed, a restatement of an existing
`knowledge/` entry, a style preference with no defect behind it, or a "consider
maybe someday" with no failure scenario. A tracker of speculative items is worse
than no tracker — it makes the real ones harder to find.

## Search first

Always, before writing anything:

```bash
gh issue list --repo adamayoung/TMDb --state all --search "<distinctive term>"
```

Use a term from the *symptom*, not your phrasing of the fix — the same defect
gets described three ways. Prefer **commenting on the existing issue** with the
new evidence over opening a near-duplicate. If it is genuinely distinct but
related, file it and cross-link both ways in the body.

## Body template

Every section earns its place: `/triage-issues` re-verifies against these, and a
body without them takes a triage pass to become actionable — which is a pass
nobody scheduled.

```markdown
**Origin:** <what surfaced it — the PR, review, or sweep, and why it was left
out of that change's scope. "Deliberately deferred" and "overlooked" are
different facts; say which.>

## Problem

<What is wrong, in the code's terms. Cite `path/to/File.swift:LINE` — plural,
one per claim. State the version you checked against: "as of `main` @ <sha>".>

## Failure scenario

<Concrete inputs or state → wrong output, crash, or silent loss. Not "this
could be a problem" — the actual path. If you verified it live, say so and give
the numbers.>

## Fix sketch

<Enough for someone else to start without re-deriving your analysis. Name the
files, the shape of the change, and the in-repo precedent to copy if one
exists.>

**Breaking class:** none | source-breaking | behavioural | needs a decision
```

Add `**Decision needed:**` as its own line when the fix is not determined — one
sentence naming the choice, not a discussion of it. An issue whose fix approach
is undecided is not ready for anyone to pick up, and saying so in one line is
cheaper for every later reader than leaving them to discover it.

### Two conventions that are easy to get wrong

- **Line numbers rot.** They are still worth giving — they are how a triage pass
  re-verifies you — but say which commit they are as of, so a reader knows
  whether to trust them.
- **This repo's numbers interleave issues and PRs.** A bare `#NNN` is ambiguous.
  Write "issue #NNN" or "PR #NNN" in words, and check with
  `gh api repos/adamayoung/TMDb/issues/NNN --jq .pull_request` if unsure.

## Filing it

```bash
gh issue create --repo adamayoung/TMDb \
  --title "<symptom, not solution — what is wrong, in one line>" \
  --label "<bug|enhancement|documentation|question>" \
  --body-file <path>
```

Then **add it to the board's Backlog column** — an issue that is not on the board
is invisible to `/triage-issues` until its orphan sweep catches it.

Use the **GitHub MCP**, not `gh project`: ADR-0009 makes the MCP the default, and
`gh project` needs a `read:project` token scope this repo's usual token does not
have, so it fails on the first call.

```text
mcp__github__projects_list  / list_projects       → the project titled "TMDb"
mcp__github__projects_write / add_project_item    → owner/repo + issue_number
mcp__github__projects_write / update_project_item → Status = "Backlog"
```

Set Status explicitly rather than trusting the board's "Item added" automation —
whether it is enabled cannot be checked through the API, and an item that lands
with no Status is one `/triage-issues` will never groom.

Do **not** set Priority or Size. Those are `/triage-issues`' output; guessing them
at filing time gives one judgement two owners.

## Board status — the column lifecycle

Filing owns only the first column. Each later move is owned by the skill that
causes it, and this table is the **one place the column names and the write idiom
are written down** — so a renamed column is a one-file fix rather than a hunt
through four skills.

| Column | Set by | When |
| --- | --- | --- |
| **Backlog** | whoever files (this spec) | the issue is created |
| **Ready** | `/triage-issues` | it passes the Ready test; Priority + Size are set with it |
| **In progress** | `/deliver` (Phase 1, or Phase 0 for `next`) | the worktree is entered — or, in `next` mode, the moment the issue is picked |
| **In review** | `/watch-pr` (§3, at *ready*) | the PR is green and mergeable, waiting on a human |
| **Done** | the board's own "item closed" automation | the PR merges and closes the issue |

Three **reverse** transitions exist, all belonging to `/deliver`, all there
because `next` is the only thing in the repo that takes work off the board
without a human choosing it:

| Column | Set by | When |
| --- | --- | --- |
| **Ready → Backlog** | `/deliver next` (selection) | a Ready candidate fails re-verification against `origin/main` — its claims no longer hold, or its fix approach turns out to be undecided |
| **In progress → Ready** | `/deliver next` | the run stops before its PR opens, releasing an issue it had claimed |
| **In progress → Ready** | `/deliver` Phase 1 reconcile, **any mode** | a *different*, dead `next` run left a claim behind — released by the next run's sweep, on a `conductorPid` liveness test |

The last two are one obligation with two writers, and they cannot both fire:
the first runs only while that run's conductor is alive to reach its stop
report, the second only once that conductor's PID is proven dead. Splitting
them is what makes the claim recoverable at all — a run killed by context
exhaustion, a dropped MCP or a closed terminal reaches no stop report, and
would otherwise hold its issue forever.

None of the three gives a column a second owner: `/triage-issues` still owns
*promotion* into Ready, and `/deliver` still owns the move into In progress.
What they add is an owner for undoing each — which nothing had. A `next` run
that rejects a candidate but leaves it in Ready re-rejects the same issue on
every future run while the queue behind it stays unreachable, because
`/triage-issues` is scoped to Backlog and never re-examines a Ready item. A
`next` run that claims an issue and then dies strands it in In progress, which
**only that reconcile sweep** can move it out of — `/triage-issues` is
forbidden to touch the column, and `next` itself reads only Ready. Both are
silent, and both drain the queue.

**Done is deliberately not written by any skill.** It is the one transition
observed to happen unaided: `/triage-issues` closes `wontfix` issues without
touching Status and they land in Done regardless. A write for it would give one
column two owners. If a merged issue is ever seen *not* reaching Done, that
automation has been turned off — and this row is where to record that.

The call is the same for every row, so it is stated once, here:

```text
mcp__github__projects_write / update_project_item
  owner: adamayoung · project_number: <resolve "TMDb" via projects_list>
  item_owner: adamayoung · item_repo: TMDb · issue_number: <n>
  updated_field: { "name": "Status", "value": "<column name>" }
```

Four things that are easy to get wrong:

- **Pass the option *name*, not its id.** The name form resolves server-side; an
  id is opaque, unreviewable in a diff, and silently wrong if a column is ever
  recreated.
- **Resolve the project number; don't hardcode it.** A hardcoded number fails
  quietly against the wrong board rather than loudly against none.
- **A board write must never fail the work.** These moves are bookkeeping. If one
  errors, say so in the run's summary and carry on — a red board write is not a
  red delivery.
- **No issue means no move.** Plenty of changes are untracked (an ad-hoc fix, a
  follow-up to a review). Skip the move and say you skipped it; never invent an
  issue so that something can be moved.

## Titles

The title is what someone scans in a list of forty. Lead with the symptom and
the blast radius:

- Good — `TaggedImageMedia doesn't model media_type "tv", so most tagged images are silently dropped`
- Bad — `Improve TaggedImageMedia` (no symptom), `Add tvSeries case` (solution, not problem)

Do not write "for the next major" or "queue for later" into a title. Whether it
waits is a scheduling decision that changes; the title outlives it, and a stale
"queue this" tells every future reader to defer the thing they should be doing.
