# /deliver — worktree lifecycle (reference)

Read on demand from `/deliver` **Phase 1** (enter) and **Phase 12** (teardown).
The rules live in `SKILL.md`; this file holds the procedures and the traps.

## GC sweep procedure (Phase 1, before entering)

This run is the garbage collector for the *previous* delivery's deferred merge —
Phase 12 only fires on an in-session merge, and the common path is "merged
later, elsewhere". Reclaim any worktree whose PR has since merged:

1. Get every PR's state in **one** call — `mcp__github__list_pull_requests`
   (owner/repo from the `origin` remote, `state: all`, `perPage: 100`) — and
   build a `head.ref → merged?` map (a merged PR reports `state: closed` +
   `merged: true`).
2. For each worktree under `.claude/worktrees/` whose branch the map marks
   **merged** (get branches with `git -C "$wt" rev-parse --abbrev-ref HEAD`):

   ```bash
   git worktree remove --force "$wt" && git branch -D "$br" 2>/dev/null
   ```

   The map comes from the MCP call; the shell step only does the removal —
   tool calls can't run inside a bash loop.

This keeps `.claude/worktrees/` (each carrying a multi-GB `.build`) from
accumulating across deliveries merged in the GitHub UI or a later session.
Empty leftover directory husks can be cleared with
`find .claude/worktrees -type d -empty -delete`.

## Entering

- `EnterWorktree(name: "feature/<slug>")` creates the worktree under
  `.claude/worktrees/` and switches the session into it. This is the
  sanctioned auto-use for `/deliver` — do it without asking.
- **Verify the branch name after entering** — the tool has been seen to name
  the branch `worktree-<slug>` (with `/` → `+`) instead of the requested name
  (`knowledge/gotchas.md`). Rename before any push:
  `git branch -m feature/<slug>` (safe — nothing is pushed yet), and confirm
  with `git branch --show-current`.
- **Base ref:** by default (`worktree.baseRef: fresh`) the branch is cut from
  **`origin/main`**; with `worktree.baseRef: head` it's cut from local HEAD —
  don't assume `origin/main` unconditionally. The `fresh` consequence: any
  **uncommitted or local-only** state (including an uncommitted on-disk plan
  file) is **absent** from the worktree — which is why Phase 0 reads the
  plan's content into the conversation first.
- **Already in a worktree?** Don't nest — use the current worktree and just
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
**and** `HEAD == @{u}`), then:

```text
ExitWorktree(action: "remove", discard_changes: true)
```

- `remove` deletes the worktree directory (which **is** its `.build` — the
  multi-GB reclaim) and the local branch, then returns the session to the
  main checkout.
- `discard_changes: true` is needed only because a **squash**-merge lands the
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
