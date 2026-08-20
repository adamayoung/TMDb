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

Then remove the candidates that are unfit before any verifier runs. The first
two are cheap, and each prevents a distinct way of delivering the same work
twice; the third defers to §5:

- **Already claimed by a PR** — an open pull request whose body carries
  `Closes #NNN` for that issue. One `mcp__github__list_pull_requests` call
  (`state: open`). This is its own call, made here in Phase 0 — Phase 1's
  reconcile sweep makes a similar one later, with `state: all`, for a different
  purpose; neither reuses the other's result.
- **Already claimed by a live worktree** — a run file under `.git/deliver/`
  whose deliverable names that `issue` and whose worktree is `live` (lock PID
  alive; see [`worktree-lifecycle.md`](worktree-lifecycle.md)).
- **Unfit for `merge` mode** — breaking (§5a) or reflexive (§5b). Only in
  `merge` mode, and a skip rather than a rejection.

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
| `needs-decision` | sound, but the fix approach is not determined — a `**Decision needed:**` line, a `question` label, an open `dependsOn` from the marker's `deps=`, or an explicit `**Breaking class:** needs a decision` |

plus the **one deciding fact** and **what it checked first-hand**. A verifier
that cannot name what it checked votes `stale`.

**A dead verifier is not a `startable`.** Retry once; still dead or unusable →
**pass the candidate over** — leave it in `Ready`, do not comment, do not count
it against the reject cap, and move on. This is deterministic on purpose:
"fall back to deciding it yourself" would hand the startability call to the
party with an interest in continuing, which is the whole reason the dead-grader
rule exists in Phase 6.

Pass over rather than reject, because a dead verifier is a fact about the
**harness**, not about the issue. Demoting a healthy `Ready` issue and
commenting on it because a subagent died blames the board for a tooling
failure — and there is no verdict to put in the comment's marker anyway. For
the same reason, **two dead verifiers in one run stop the run**: repeated
verifier death means the harness is broken, and continuing would silently pass
over the whole queue and report "nothing startable", which reads as a board
problem. Say which it was.

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

  **Never skip the comment on a run that actually performed the move.** The
  demotion's whole exit route is that bumped `updated_at`: a Project field write
  does **not** touch the issue's own timestamp, so a silent demotion leaves
  `/triage-issues`' skip condition satisfied, its Phase 3 carries the stale
  `exit: ready` marker forward, and Phase 7 promotes the issue straight back to
  `Ready` without re-examining it — the poisoned head returns, unexamined and
  now with a triage run's apparent blessing. So the idempotency skip applies
  only when the item was **already** in Backlog; if this run wrote
  `Ready → Backlog`, always post or refresh the marker comment.

**Cap the rejects per run, not from the head.** Stop when either the whole
candidate list is exhausted or **5** candidates have been **rejected** in this
run. Only a §4 verdict is a reject. Everything else is **passed over, not
rejected** — no verifier ruled on it, nothing is wrong with it, and it neither
counts against the cap nor earns a comment. That is the whole of the other
list, so check a new case against it rather than inventing a third:

- removed by a §2 filter — closed, no longer `Ready`, or already claimed by an
  open `Closes #NNN` PR or a live worktree;
- skipped by §5's `merge`-mode tests — breaking (5a) or reflexive (5b);
- lost to a concurrent claim at §6 step 1;
- **its verifier died twice** — a fact about the harness, not the issue.
A "3 consecutive rejects" rule counted from the head would let three stale items
brick `next` permanently while startable work sat at position 4. Report
`n rejected, picked #m` in one line either way.

Nothing startable → **stop before any worktree**, list what was rejected and
why, and recommend `/triage-issues`.

## 5 — What `merge` mode refuses

Everything in this section is **scoped to `merge` mode** and is a
**skip**, not a rejection: the candidate is passed over for this run and left
exactly where it is on the board. Nothing here demotes anything, and outside
`merge` mode none of it is read at all — §4's verifier alone decides
startability. Keep that boundary: an earlier draft let the `Breaking class`
default leak into every mode, which on the board as it stands would have
demoted nine perfectly good `Ready` issues on the first run.

`/deliver auto merge next` is the only invocation that can take an issue from a
board to a merged commit with nobody looking. Three properties make a candidate
unfit for that, and all are knowable before Phase 1: it is **breaking** (5a), it
is **reflexive** (5b), or it was **written by someone outside this repo** (5c).

Two of the three are read out of the issue body, which is why 5c exists — the
first two ask the issue to certify itself, and 5c asks who signed the
certificate.

### 5a — A breaking change

The body template
([`.github/ISSUE_FILING.md`](../../../../.github/ISSUE_FILING.md)) ends every
issue with `**Breaking class:** none | source-breaking | behavioural | needs a
decision`. **In `merge` mode, a candidate is selectable only if its class is
`none`.**

Read the class **defensively — real bodies vary**, and the three shapes seen on
the live board are not interchangeable:

| Shape | Example | Read as |
| --- | --- | --- |
| Inline bold label | issue 437: `**Breaking class:** adding a case … is source-breaking for exhaustive switches` | the label's text, not a bare enum value |
| Its own heading | issue 448: `## Breaking class` / `None — CI configuration only.` | the section's first sentence |
| **Absent** | issue 426 carries no class at all | **not `none`** — so unselectable in `merge` mode, and nothing more |

So: find the label in either form, take the prose that follows, and treat it as
`none` **only** when that prose actually says so. Anything else — a qualifier, a
sentence you are not sure about, or no label at all — is **not** `none`. The
default matters more than the parse: an unlabelled issue is the one nobody
classified, which is the last one to merge unread.

**Absence is not a verdict about the issue**, only about merging it unattended.
An unlabelled issue is still perfectly deliverable by `/deliver next` and
`/deliver auto next`; it just stops at the human gate, which is where an
unclassified compatibility question belongs. Only an issue **explicitly**
classed `needs a decision` is a §4 rejection, and then because its fix approach
is undecided — not because of this section.

`auto-and-async.md` already states why this filter is worth its pickiness: this
is a single-maintainer package with public API surface *"where the
ready-to-merge human gate is deliberate — every change is a compatibility call
worth a human's eyes"*. Without it, `/deliver auto merge next` would have
squash-merged a milestone-20.0.0 behavioural change on the day it shipped.
Without `merge`, `/deliver auto next` still delivers those issues — it just
stops at the gate, which is exactly where a compatibility call belongs.

> **Expect `merge` mode to be picky, and say so when it is.** On the board at
> the time of writing, **3 of the 12** `Ready` issues carry a Breaking-class
> line at all, so `/deliver auto merge next` will often report "nothing
> selectable" while `/deliver auto next` has plenty to do. That is the template
> being backfilled over time, not a fault — report which candidates were skipped
> for a missing class, so the gap is visible rather than mysterious.

### 5b — A reflexive change

An issue whose fix touches the **reflexive set** — `.claude/skills/**`,
`.claude/agents/**`, `.claude/workflows/**` or `.github/CODE_REVIEW.md` — is
**not selectable in `merge` mode either**, whatever its Breaking class. Judge it
from the issue's own fix sketch and the files it names, at the same moment as
the class, and **resolve any doubt as reflexive**.

That set is defined in `SKILL.md` Phase 0 and quoted here; the two must match
exactly, because Phase 10's backstop keys on Phase 0's computation rather than
on this test. When they drifted — this list carrying `.claude/workflows/**` and
Phase 0's not — the backstop covered three quarters of what this gate refuses,
and the missing quarter was the one holding `deliver-panel.js`.

This closes a hole the Breaking-class filter does not cover: those files carry
no public API, so a reflexive issue reads as `none`. Issue 467 is the live
example — P2, small, touches `.claude/agents/**` — and `auto merge next` would
otherwise have selected it, drafted its own plan, and squash-merged **a rewrite
of the delivery machinery with nobody reading it**. That is the exact thing
[`deliver-panel.js`](../../../workflows/deliver-panel.js) says must never
happen: *"a `proceed` must never authorise an unattended run to edit and push
the repo's own skill files"*. Before `next`, a human chose to deliver a skill
change unattended; the machine must not choose it for them.

Phase 0 already computes `reflexive` for the drafted plan, so **Phase 10 drops
the `merge` opt-in** whenever the run file says `reflexive: true` and
`mode: next` — belt and braces, in case the fix sketch understated the
footprint. The run still delivers; it just stops at the gate.

### 5c — An issue this repo's maintainers didn't write

Both tests above read the **issue body**, and 5b also reads its fix sketch. That
text is written by whoever opened the issue. `adamayoung/TMDb` is a **public
repository**, and `/triage-issues` sweeps *every* open issue onto the board, so
an issue reaching `Ready` is not evidence that a maintainer chose it.

**In `merge` mode, a candidate is selectable only if its `author_association`
is `OWNER`, `MEMBER` or `COLLABORATOR`** — and the same is required of the
`<!-- triaged: … -->` marker comment §4 relies on. Anything else, including
`CONTRIBUTOR` and `NONE`, is not selectable. Read it from the issue and the
comment (`mcp__github__issue_read` returns it); absent or unrecognised counts as
untrusted, like every other default in this section.

Without this, the two properties authorising an unattended merge are **supplied
by the party whose work is being authorised** — they write the defect, the fix
sketch, the `Breaking class: none` line, and (via the *Failure scenario* section
§6 derives the rubric from) the acceptance criteria their own change will be
graded against. Nothing in the path re-derives any of it from the code. That is
a supply-chain path into `main` of a published package, and an author check is
the cheap, decisive cut across it.

This only ever *narrows* `merge`. An outside contributor's issue is still
delivered by `/deliver next` and `/deliver auto next` — it simply stops at the
human gate, which is exactly where a stranger's proposal should stop.

## 6 — Claim the issue, then draft

**Claim before drafting.** The moment a candidate is `startable`:

1. **Re-read the item's `Status` immediately before writing.** Anything other
   than `Ready` means another run claimed it during your verification — a
   subagent call, so a window of minutes. Treat it as a **lost race**: move to
   the next candidate, and do not count it against the reject cap (nothing was
   wrong with the issue).
2. Write `Status = In progress` (call:
   [`.github/ISSUE_FILING.md`](../../../../.github/ISSUE_FILING.md) →
   *Board status*).
3. **Re-read once more to confirm the write landed** — a board write is
   non-fatal by policy, so a failed one is otherwise silent. Still not
   `In progress` → retry once, then **proceed unclaimed**: record
   `"claimed": false` in `selection` and say in the report that the board does
   not reflect this run. Do not stop (a board write never fails the work) and
   do not pretend it landed — both the §6 release obligation and Phase 1's
   sweep key off that flag, and a run that believes it holds a claim it does
   not will "release" an issue another run is delivering.
4. **Write the claim to the run file *now*, before drafting anything.** The
   moment the re-read settles, persist three things: `selection.picked`,
   `selection.claimed`, and the deliverable's `issue`. The rest of `selection`
   can wait for the end of selection; these three cannot.

   This ordering is the whole recovery mechanism, not bookkeeping. Between the
   board write and the end of drafting sit a `Plan` agent invocation and,
   attended, an unbounded wait at the approval stop — and a user who reads the
   plan, wanders off and closes the terminal is the likeliest way this mode ever
   dies. A run that dies there with the issue unwritten matches Phase 1's sweep
   predicate exactly (`next` mode, `pr: null`, `status: open`, no stamp,
   `claimed` absent) **and names no issue to hand back**, so the strand is
   unrecoverable by the mechanism built for it, in precisely the window the
   early claim exists to cover.

Step 1 narrows the race; it does not eliminate it. `update_project_item` is a
blind overwrite with no compare-and-swap, so two runs that re-read in the same
instant still both proceed. Do not describe this as making concurrent claims
impossible — it makes them improbable, and the remaining window is small enough
that the Phase 1 exclusions (an open `Closes #NNN` PR, a live worktree) catch
what is left.

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

**And a release that depends on a live conductor is not enough.** The rule above
presupposes reaching a stop report; the commonest end of an unattended run —
context exhaustion, a killed session, a dropped MCP — reaches none, and leaves
the claim held forever. So the recovery is **also** owned by the next run's
Phase 1 reconcile sweep, which releases the issue of any `next` run that never
opened a PR **and whose `conductorPid` is dead**
([`worktree-lifecycle.md`](worktree-lifecycle.md)).

That sweep **stamps `claimHandedBack` on the deliverable it released** (not on
the run file as a whole — a batch releases each qualifying deliverable
independently), and skips any deliverable already carrying it — so the release
happens once. Left unstamped, the
sweep's predicate is still true afterwards and every later run re-releases the
same issue; the moment it has been legitimately re-claimed, that repeat takes it
away from a live delivery. It also skips any run recording
`selection.claimed: false`, which never held the issue at all.

Two owners for one release is deliberate, and it is not the ambiguity the
one-owner rule guards against — but only because of that PID test, so do not
weaken it to something cheaper. They cannot both fire: the first runs only
while the conductor is alive, the second only once it is **proven** dead. The
worktree buckets look like they would serve and do not: `settled` performs no
liveness test at all, and a `next` claim is held from Phase 0, *before any
worktree exists*. A bucket-keyed sweep would therefore either release a live
conductor's claim while it sits at the approval stop — handing the issue to a
concurrent run, which is the double-delivery the early claim exists to
prevent — or never see the pre-worktree window, which is where the claim
actually lives.

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

Written into the run file at the end of selection — **except `picked` and
`claimed`, which are written at §6 step 4, the instant the claim settles and
before any drafting** — and **read by Phase 6**: a
run whose run file records `mode: next` with `selection` missing or empty
**hard-stops at the exit gate**, exactly as a missing `reconciled` block does.
Without that, `selection` would be telemetry nobody checks — a green
indistinguishable from never having run.

```json
"mode": "next",
"selection": {
  "source": "board-fields (no run-list line; deps/contention unknown)",
  "verifiedAt": "527682f7",
  "listed": 12,
  "passedOver": [
    { "issue": 434, "why": "filtered by §2 — closed, still showing Ready" },
    { "issue": 437, "why": "skipped by §5a — Breaking class source-breaking, merge mode" }
  ],
  "rejected": [
    { "issue": 426, "verdict": "needs-decision", "why": "body offers three competing fixes; demoted to Backlog" }
  ],
  "picked": 448,
  "breakingClass": "none",
  "claimed": true
}
```

`claimed` is **not** decoration. It is read by Phase 1's reconcile sweep, which
skips any run file recording `claimed: false` — that run never held the issue,
so there is nothing to hand back, and by the time the sweep runs someone else
may legitimately hold it. Write it on every `next` run, both values.

Note what the two lists mean, because the distinction is load-bearing:
`rejected` holds candidates a **verifier** ruled on — each one was demoted and
counts against the cap — while `passedOver` holds candidates that never reached
a verifier and were left exactly as they were. An entry in the wrong list either
demotes an issue that was fine or hides one that is not.
