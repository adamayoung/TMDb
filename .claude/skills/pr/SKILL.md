---
name: pr
description: Create a pull request
---

# Create a pull request

I'll create a pull request for the current branch by following these steps. If any steps fail, stop.

**Mode** — check the arguments passed to this skill (shown at the end). If they
include `reviewed` (or `skip-review`), an upstream step already ran the
`code-reviewer` and fixed its findings (e.g. `/deliver`'s code-review phase), so
**skip steps 4–6** to avoid reviewing identical code twice. Otherwise (standalone
`/pr`), run the internal review as normal.

**Also skip steps 4–6 when the branch changes no Swift** — code review is for
Swift, so a docs-only / config-only PR needs none:

```bash
git diff --name-only main...HEAD | grep -qE '\.swift$' || echo "no-swift → skip review"
```

1. Run `/format` to format code
2. **Commit all outstanding work.** Run `git status`. If the working tree has **any** uncommitted or unstaged changes (the feature work, plus the formatting from step 1), stage and commit them — the PR reflects **committed history only**, so anything left uncommitted will be **missing from the PR**. First **verify no secrets, `.env`, or build artifacts** are included (per CLAUDE.md — `.env` must stay gitignored; check `git status` before `git add`). Use a descriptive gitmoji message (or several logical commits if the work spans concerns); formatting-only changes can use "🎨 apply code formatting". If the tree is already clean (e.g. work was committed during `/deliver`), this is a no-op.
3. **Rebase onto the latest `main`.** Bring local `main` up to date with remote, then rebase the feature branch onto it — do this **before** `make ci` so the gate (and the eventual PR) reflects the real merge result, not stale code:

    ```bash
    git fetch origin
    git checkout main && git merge --ff-only origin/main   # local main == remote main
    git checkout -                                          # back to the feature branch
    git rebase main
    ```

    - If `git merge --ff-only` fails, local `main` has diverged from `origin/main` — **stop** and investigate; do not force it.
    - If `git rebase` reports conflicts, **stop**, resolve them, then continue. Never skip or force past a conflict you don't understand.
    - The rebase rewrites the branch tip, so a branch that was **already pushed** will need `git push --force-with-lease` at the push step below.
    - Already on / branched directly off an up-to-date `main` with nothing to replay → this is a fast no-op.
4. Run `make ci` — **MANDATORY; it must pass before going further.** This is the full gate CLAUDE.md requires before any PR: it runs lint, markdown lint, unit tests, integration tests, the release build, and the docs build. Run it directly (do not delegate). If it fails, stop and fix — **commit the fixes** — then re-run; never open a PR on a red gate.
5. *(skip in `reviewed` mode or when no Swift changed)* Spawn the `code-reviewer` agent to perform a code review of all changes (pass the git diff output as context)
6. *(skip in `reviewed` mode or when no Swift changed)* Summarize the code review findings:
    - List any critical or high-severity issues that should be addressed
    - List any medium-severity suggestions for improvement
    - Note any low-severity or stylistic recommendations
7. *(skip in `reviewed` mode or when no Swift changed)* If there are critical/high-severity issues:
    - Recommend specific changes needed
    - Ask user for confirmation before proceeding (fix issues or continue anyway)
    - If user wants to fix issues, stop and let them address the feedback
8. **Ensure a clean working tree before pushing.** Re-run `git status`; commit anything still outstanding (e.g. review fixes from steps 5–7, or `make ci` fixes) so the push includes **everything**. The tree must be clean before proceeding. Then run `git diff origin/main...HEAD` to understand all changes going into the PR.
9. Analyze the commits and changes to generate an appropriate title and summary
10. Push the current branch to remote (`git push -u origin <branch>` if not yet pushed; otherwise `git push` — use `git push --force-with-lease` if you rebased in step 3)
11. Create a PR using `gh pr create` with:
    - **IMPORTANT: Title MUST start with a gitmoji prefix** (e.g., "✨ Add new feature", "🐛 Fix bug", "📝 Improve documentation")
        - Refer to <https://gitmoji.dev> to use the correct emoji
        - Common: ✨ feature, 🐛 bugfix, ♻️ refactor, ✅ tests, 📝 docs, 🔧 config, 🎨 style
    - A comprehensive summary with bullet points
    - Proper formatting with sections (Summary, Changes, Benefits, etc.)

The PR will include the Claude Code attribution footer.

$ARGUMENTS
