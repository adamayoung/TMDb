# /deliver — worktree lifecycle (reference)

Read on demand from `/deliver` **Phase 1** (enter) and **Phase 12** (teardown).
The rules live in `SKILL.md`; this file holds the procedures and the traps.

## Reconcile sweep procedure (Phase 1, before entering)

This run is the garbage collector for the *previous* delivery's deferred merge —
Phase 12 only fires on an in-session merge, and the common path is "merged
later, elsewhere". It also catches runs that **died before opening a PR**, which
the old merged-PR-keyed sweep could not see at all.

> **Enumerate with `git worktree list --porcelain` — never `ls
> .claude/worktrees/`.** That directory is a **CWD-relative** path that **does
> not exist inside a worktree**, so the old sweep silently enumerated *nothing*
> whenever `/deliver` ran from one — passing while doing no work. A sweep that
> reports "0 items, all clean" because it looked in the wrong place is the
> **False green** family (`knowledge/gotchas.md`).

**Scope: only worktrees under `<main-root>/.claude/worktrees/`.**
`git worktree list` reports the **main checkout first** and every worktree of
the repo, including ones you created by hand elsewhere. Skip the main checkout
and anything outside that directory — a worktree `/deliver` did not create is
outside its remit, and removing a hand-made workspace is not a GC, it is data
loss.

```bash
main_root=$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')
git worktree list --porcelain | awk -v r="$main_root/.claude/worktrees/" \
  '/^worktree /{p=$2} /^branch /{if (index(p, r)==1) print p, $2}'
```

1. Get every PR's state in **one** call — `mcp__github__list_pull_requests`
   (owner/repo from the `origin` remote, `state: all`, `perPage: 100`) — and
   build a `head.ref → {open, merged}` map (a merged PR reports `state: closed`
   + `merged: true`). Tool calls can't run inside a bash loop, so gather first,
   then act.
2. Classify each in-scope worktree **top-to-bottom, first match wins** — the
   rows overlap deliberately, so order carries the safety:

   | # | Bucket | Test | Action |
   | --- | --- | --- | --- |
   | 1 | `live` | lock PID **alive** | **Never touch.** Another session owns it |
   | 2 | `report` | lock absent, unparseable, or not written by `/deliver`; `@{u}` errors; removal refused | **Report, never remove** |
   | 3 | `reclaim` | PR **merged** *and* both Phase 12 proofs | Unlock → remove → **verify gone** |
   | 4 | `resumable` | PID **dead**, run file `open`, **no PR at all** | Adopt, or leave standing |
   | 5 | `settled` | run file whose worktree is already gone | Close the file; no worktree action |
   | 6 | `report` | everything else | **Report, never remove** |

   Rows 2 and 6 make this total: **nothing can fail to classify**, so the sweep
   can never brick the pipeline on an unrecognised state.

3. Record one ledger line: `swept: <n> in scope / <k> reclaimed / <r> resumable
   / <o> reported`.

### Liveness is a fact, not a timeout

`EnterWorktree` writes `.git/worktrees/<name>/locked` containing
`claude session <branch> (pid <PID> start <time>)`. **Test the PID** —
`kill -0 <pid>` — and never infer liveness from a file's age: a normal Phase 3
or Phase 9 goes quiet for far longer than any plausible timeout, so an
mtime heuristic will eventually adopt a **running** delivery and put two
conductors and two Swift builds in one scratch directory.

+ PID **alive** → `live`. Never touch, under any circumstances. (Treat an
  `EPERM` from `kill -0` as alive.)
+ PID **reused** by an unrelated process is possible on a long-lived machine;
  it fails *safe* (a false `live`). To avoid blocking resume forever,
  cross-check the lock's `start` against `ps -p <pid> -o lstart=`.
+ Lock **absent, unparseable, or not `/deliver`'s** → `report`. Never guess.
+ The lock **outlives the session that made it**, so a dead-session worktree is
  still locked: `git worktree remove --force` **refuses** on it. Unlock first
  (`git worktree unlock <path>`), and if removal still refuses, that is bucket 2
  — report it with the unlock hint. **A refused removal must never be counted as
  `reclaimed`**; verify the directory is gone before reporting one.

### Removal keeps Phase 12's proofs

Reclaiming uses the *same* two proofs Phase 12 demands, not a weaker bar:
`pull_request_read → merged: true`, **and** `git status --porcelain` empty
**and** `git rev-parse HEAD` equal to `git rev-parse @{u}`.

> `@{u}` **errors** (rather than returning false) on a never-pushed branch, so
> treat that as *unproven* → `report`, not as a failed comparison.

```bash
git worktree unlock "$wt" 2>/dev/null
git worktree remove "$wt" && git branch -D "$br" 2>/dev/null
test -d "$wt" && echo "STILL PRESENT — report, do not count as reclaimed"
```

`git branch -D`, not `-d`: this repo squash-merges with `deleteBranchOnMerge`,
so the branch's commits are never literally on `main` and `-d` refuses once the
remote-tracking ref is pruned — leaking the branch while the sweep reports
success.

Empty leftover directory husks can be cleared with
`find "$main_root/.claude/worktrees" -type d -empty -delete`.

## Run state, reconcile & resume

The `TaskCreate` ledger is **not** durable — `SKILL.md` states it is cleared by
`EnterWorktree`, an MCP reconnect, or a plan-mode exit. So a run that dies
mid-pipeline loses the rubric, the decomposition and every phase's status. The
run file is the durable half.

**Location:** `$(git rev-parse --path-format=absolute --git-common-dir)/deliver/<id>.json`
— i.e. `<main checkout>/.git/deliver/`. Chosen because it **cannot enter a diff
by construction** (`.git` is not a working-tree path, so it can never appear in
`git status`, `git diff`, or `git add -A`), it is **shared by every worktree**
via the *common* dir so batch state is reachable from any of them, and it
**survives `ExitWorktree(remove)`** so deliverable 1's teardown doesn't destroy
the state of deliverables 2..N. `<id>` is the slug plus an ISO timestamp — the
branch does not exist yet when Phase 0 writes it.

**The gate is a data dependency, not a checklist item.** Phase 0 writes the file
**before** Phase 1; Phase 1 records its reconcile result into it; **Phase 6
reads the rubric from it**. Skipping the sweep therefore doesn't merely omit a
step — it removes the input a later *mandatory* phase requires, so the run fails
loudly instead of silently. **A missing run file at Phase 6 is a hard stop**,
exactly as a dead grader is not a pass. `rubric: none` (present, empty) is the
sanctioned rubric-less path and is *not* the same as a missing file.

```json
{
  "id": "harden-delivery-skills-2026-07-29T19:28:23Z",
  "goal": "…", "weight": "full",
  "reconciled": { "inScope": 1, "reclaimed": 0, "resumable": 0, "reported": 0 },
  "deliverables": [{
    "title": "…", "dependsOn": [],
    "worktree": "…/.claude/worktrees/chore+harden-delivery-skills",
    "branch": "chore/harden-delivery-skills",
    "entry": "created",
    "rubric": ["Given …, when …, then …"],
    "stamps": { "reviewedClean": "<content hash>", "securityClean": null,
                "rubricGraded": null },
    "openFindings": [], "knowledgeCandidates": [], "pr": null,
    "status": "open"
  }]
}
```

A **batch is the N=1 case generalised** — more entries in `deliverables[]`. No
separate mechanism, and it is the only state that survives Phase 10's
background-watch handoff, where the conductor moves to the next worktree.

### Stamps: hash content, never a commit

`/pr` rebases onto `origin/main`, which **rewrites every SHA**, so a commit-sha
stamp is void after every rebase by construction. And Phases 7-9 commit to
`knowledge/` (capture, retro, PR-number backfill), which would void a
commit-based stamp for changes nobody needs re-reviewed. Hash the *reviewable
content* instead:

```bash
git ls-tree -r HEAD | grep -v $'\tknowledge/' | git hash-object --stdin
```

> **Not `git ls-tree -r HEAD -- . ':!knowledge'`** — `ls-tree` has no exclude
> pathspec magic; it fails, `hash-object` reads empty stdin, and you get git's
> empty blob `e69de29b…` *every time*, so two stamps compare equal while
> measuring nothing (`knowledge/gotchas.md`).

**Honouring an equal stamp also requires `git status --porcelain` empty** — the
stamp hashes `HEAD` only, so uncommitted or untracked post-review edits are
invisible to it. Equal stamp **and** clean tree → the review still holds;
anything else → re-review. When the whole diff vs `main` is under `knowledge/`
the stamp is **vacuous** (it cannot move), so re-grade rather than inherit.

**Resume rule:** re-enter the recorded worktree, restore rubric, decomposition,
findings and knowledge candidates into a fresh ledger, then advance to the
**earliest** phase whose evidence is absent or whose stamp no longer matches.
Phases 1, 3, 7, 8, 9, 10 and 12 have ground truth in git or the PR — trust that
over the file. Phases 4, 5 and 6 leave no trace, which is exactly why they are
stamped.

### Adoption

Enter an existing worktree with `EnterWorktree(path: <recorded path>)` and set
`entry: "adopted"`. Flip the run file's status **before** re-locking, so two
concurrent resumes cannot both adopt. Abandoning a resumable run instead
requires the branch **pushed** or the worktree **left standing** — abandonment
must never destroy unpushed commits.

## Entering

+ `EnterWorktree(name: "feature/<slug>")` creates the worktree under
  `.claude/worktrees/` and switches the session into it. This is the
  sanctioned auto-use for `/deliver` — do it without asking.
+ **Verify the branch name after entering** — the tool has been seen to name
  the branch `worktree-<slug>` (with `/` → `+`) instead of the requested name
  (`knowledge/gotchas.md`). Rename before any push:
  `git branch -m feature/<slug>` (safe — nothing is pushed yet), and confirm
  with `git branch --show-current`.
+ **Base ref:** by default (`worktree.baseRef: fresh`) the branch is cut from
  **`origin/main`**; with `worktree.baseRef: head` it's cut from local HEAD —
  don't assume `origin/main` unconditionally. The `fresh` consequence: any
  **uncommitted or local-only** state (including an uncommitted on-disk plan
  file) is **absent** from the worktree — which is why Phase 0 reads the
  plan's content into the conversation first.
+ **Already in a worktree?** Don't nest — use the current worktree and just
  create the branch in it (`git checkout -b feature/<slug>`). `EnterWorktree`
  refuses to nest anyway.

## Restore the permission allowlist

Credentials are **not** the concern — `TMDB_API_KEY` / `USERNAME` / `PASSWORD`
are injected into the session's **process environment** at startup
(CWD-independent), and `make ci` / `make integration-test` read them straight
from the environment. What a fresh worktree lacks is the **gitignored
`.claude/settings.local.json`**, which holds the **permission allowlist** —
without it an autonomous run could stall on permission prompts. Copy it in as
cheap insurance:

```bash
# CWD is the worktree; the main checkout is the first entry of `git worktree list`.
main_root=$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')
mkdir -p .claude
cp "$main_root/.claude/settings.local.json" .claude/settings.local.json 2>/dev/null || true
```

It stays gitignored in the worktree, so it won't be committed. If `make ci`'s
integration leg fails on **credentials**, the cause is the *env* not being
inherited by whatever spawned the subshell — **not** this file; check the
environment first.

## The main-checkout path trap

A file `Read` *before* `EnterWorktree` yields a **main-checkout** absolute
path; continuing to `Edit` that exact path after entering writes to **`main`**,
not the worktree (they share `.git` but have **separate working dirs**). The
trap is self-concealing: the build/test then runs against the still-pristine
worktree and returns **baseline** counts, so a green run "confirms" work that
never landed (bit #359 via fanned-out subagents and #361 via the conductor —
see `knowledge/gotchas.md` → *Edits can land in the main checkout*).

Hence the Phase 1 checkpoint: after entering, **re-`Read` source files before
editing them**, and **verify `git status` shows your diff in the worktree
before trusting the first green build** (an empty diff + baseline test counts
= edits went to `main`). Rescue stranded edits with a shared stash:
`git -C <main-checkout> stash` then `git stash pop` in the worktree. When
fanning work out to subagents, give them worktree-absolute paths explicitly.

## Teardown procedure (Phase 12)

Both preconditions from `SKILL.md` verified (PR `merged: true`; tree clean
**and** `HEAD == @{u}`), then **branch on how the worktree was entered** — the
run file's `entry` field.

**`entry: "created"`** (this session made it) — the normal path:

```text
ExitWorktree(action: "remove", discard_changes: true)
```

**`entry: "adopted"`** (resumed from a previous run via `EnterWorktree(path:)`) —
`ExitWorktree` **only operates on worktrees it created in this session**, and
its own contract says a worktree entered by `path` "will not be removed; use
`action: "keep"`". Calling `remove` here **silently no-ops while you report a
reclaim** — a false green. Do it by hand instead:

```text
ExitWorktree(action: "keep")     # return to the main checkout first
```

```bash
git worktree unlock "$wt" 2>/dev/null   # EnterWorktree locked it
git worktree remove "$wt" && git branch -D "$br"
test -d "$wt" && echo "STILL PRESENT — report, do not count as reclaimed"
```

**Either path verifies the directory is gone before reporting a reclaim.**
`-D` not `-d`, for the squash-merge reason below.

+ `remove` deletes the worktree directory (which **is** its `.build` — the
  multi-GB reclaim) and the local branch, then returns the session to the
  main checkout.
+ `discard_changes: true` is needed only because a **squash**-merge lands the
  work as a *new* commit on `main`, so the branch's pushed-and-merged commits
  aren't *literally* on `main` and `ExitWorktree` would otherwise refuse. It
  is safe **only because** the preconditions proved there's nothing un-merged
  left to lose. Never pass it on an unverified tree.

**Leave the main checkout as you found it.** Do *not* auto-`merge --ff-only`
it: the user may be actively working there with uncommitted or diverged state.
Only if it is **clean and on `main`** (`git status --porcelain` empty) may you
fast-forward it (`git fetch origin && git merge --ff-only origin/main`);
otherwise just note "main checkout left as-is (N commits behind)". Report the
reclaimed worktree in the final summary.
