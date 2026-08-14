---
name: cut-release
description: Cut a new TMDb release — work out the next SemVer version from the evidence, do the pre-tag housekeeping a tag would otherwise freeze in place, draft release notes, then tag and publish the GitHub release. Presents the version (with its reasoning) and the full notes for approval and STOPS; nothing is tagged or published until you say go.
---

# Cut Release

Takes `main` from "a pile of merged PRs" to "a tagged, published release".

**This skill is never headless.** Every other skill in this repo may decide for
itself; this one may not. A tag is the one artifact consumers resolve against —
SwiftPM will hand `20.0.0` to everyone with `from: "19.0.0"` the moment it
exists, and deleting a tag does not un-fetch it. Phases 1–5 are read-only and
local. Phase 6 is a **hard stop**. Phases 7–9 run only on an explicit go-ahead.

If invoked with no human able to answer, run to the hard stop, print the summary,
and exit. Do not tag.

## Phase 1 — Preflight

Stop on any failure; report which one and what to do.

- On `main`, clean tree, in sync with `origin/main`
  (`git status --porcelain`, `git rev-list --count main..origin/main`).
- `git fetch --tags`; establish the last release:
  `git tag --sort=-v:refname | head -1`.
- CI is **green on the exact commit being tagged**:
  `gh api repos/adamayoung/TMDb/commits/<sha>/check-runs`. A tag on a red commit
  is the one mistake with no clean undo.
- There is something to release — at least one commit since the last tag that is
  not purely a tag-housekeeping commit.

## Phase 2 — Work out the version

Two independent signals. They must agree, or you stop.

**Signal A — the CHANGELOG (authoritative).** The open `## [X.Y.Z]` section at
the top (no date = unreleased) is the *proposal*. Count `**Breaking:**` markers
inside it, and read the section headings:

- any `**Breaking:**` → **major**
- otherwise any `### Added` content → **minor**
- otherwise (`### Fixed` / `### Changed` only) → **patch**

**Signal B — the commits (cross-check).** `git log <lasttag>..HEAD`, bucketed by
gitmoji: `✨` feature, `🐛` fix, `♻️` refactor, `🔒` security, `⚡️` perf,
`🔧` chore, `📝` docs, `👷` CI, `✅` tests, `📦` build.

**Gitmoji alone is not enough to pick a version in this repo, and you must not
try.** A `🐛` here is routinely source-breaking — "stop 54 protocol conveniences
witnessing their own requirements" was filed as a fix and broke exhaustive
switches. Signal B exists to catch *omissions* from the CHANGELOG, not to
compute the bump.

Then reconcile:

- The proposed section heading must match what Signal A computes from its own
  content. A section headed `[20.0.0]` containing no `**Breaking:**` is a
  mis-labelled release — **stop and report**, do not silently downgrade it.
- `knowledge/next-major.md`'s status line names the open window. If it disagrees
  with the CHANGELOG heading, stop.
- The computed tag must not already exist.

**Coverage check.** Every commit since the last tag that touches `Sources/` and
carries a consumer-visible gitmoji (`✨ 🐛 ♻️ 🔒 ⚡️`) should be represented
somewhere in the open CHANGELOG section. List any that are not. This is the
check that catches a real change shipping invisibly; tooling-only commits
(`🔧 📝 👷 ✅`) legitimately have no CHANGELOG entry and are not flagged.

## Phase 3 — Pre-tag housekeeping

**A tag snapshots the tree**, so anything that says "unreleased" is frozen
saying it, forever, inside the very release it describes. These four are not
optional, and all of them were needed for 19.0.0 (PR #406):

1. **`README.md` install snippet.** `from: "<previous major>"` resolves to
   `>=prev, <prev+1` — on a **major**, readers following the README would never
   resolve to the new version at all. Bump it. (This is the one with real user
   impact; the other three are hygiene.)
2. **`CHANGELOG.md`.** Date the section — `## [X.Y.Z] - YYYY-MM-DD` — and add
   the link definition at the foot:
   `[X.Y.Z]: https://github.com/adamayoung/TMDb/releases/tag/X.Y.Z`. Check the
   *previous* version's definition is there too; they have been missed before.
3. **`knowledge/next-major.md`.** Rewrite the status line: this version has
   shipped, and the next major's window is now open. Remove every backlog entry
   that shipped in this release (the file's own rule). An entry left behind
   claiming to await a window that just closed is invisible exactly when it
   should fire.
4. **ADR statuses.** Every `knowledge/decisions/*.md` reading
   `Accepted (in X.Y.Z, unreleased)` becomes `Accepted (shipped in X.Y.Z)` — in
   the file **and** in the `decisions/README.md` index. Leave
   `unreleased — tooling only` ADRs alone; they describe `.claude/` machinery
   with no library impact and no version to ship in.

Prepare these as edits but **do not commit yet** — they are shown at the hard
stop, and they go up as a PR, never straight to `main`.

## Phase 4 — Draft the release notes

Structure, in this order:

1. **The opener.** Two or three sentences, warm and a little funny. Write a new
   one every time — see *Voice* below.
2. **Upgrade impact**, if this is a major or has any `**Breaking:**` entry. What
   breaks, and the one-line fix for each. This sits *above* the feature list.
3. **What's new** / **What's fixed** / **What changed** — consumer-facing prose,
   drawn from the CHANGELOG (which is already written for humans), not from
   commit subjects.
4. **Commits**, inside a `<details>` block: every commit since the last tag, one
   line each — `<sha> <subject>`. Collapsed, because it is a reference, not a
   read.
5. **Full Changelog** compare link:
   `https://github.com/adamayoung/TMDb/compare/<lasttag>...<newtag>`.

### Voice

Slack's iOS notes are the reference: they open with something human, and they
never pretend a bugfix release is a moon landing. Aim for a colleague writing
to other developers — dry, specific, occasionally silly, never markety.

- Good: naming the actual absurdity. *"This release is mostly about a movie
  database telling us, with total confidence, that Bryan Cranston has never been
  in a TV series."*
- Good: cheerful understatement. *"Eighteen of twenty tagged images were quietly
  going in the bin. They are no longer going in the bin."*
- Avoid: "We're excited to announce", "packed with", "🚀", exclamation marks in
  rows, and any claim the diff does not support.
- Avoid: whimsy about the *breaking* part. Joke about the bug you fixed, not
  about the work you have just made someone do. If this release breaks builds,
  the opener stays light but stays short — then get straight to the impact.

Length: the opener is 2–3 sentences. If it needs a fourth, it is a paragraph,
and paragraphs are what section 3 is for.

## Phase 5 — Assemble the summary

Put together, for one message:

- **Version** and the **reasoning** — the deciding evidence, not a recitation.
  "Major: 14 `**Breaking:**` entries, including four public enums gaining cases"
  beats "there were breaking changes".
- Anything Signal B flagged as missing from the CHANGELOG.
- The four housekeeping edits, as a diff summary.
- **The complete release notes**, verbatim as they will be published.

## Phase 6 — STOP

Present the summary and **wait**. Do not tag, push, or publish anything.

Ask plainly whether to go ahead. Treat anything short of a clear yes as a no —
"looks good" about the *notes* is not approval to *publish*. If the answer is a
change request, apply it and return to this phase; the gate re-arms every time.

## Phase 7 — Land the housekeeping

Only after approval. Never commit to `main` (`CLAUDE.md` → *Branching*).

Branch `chore/prepare-<version>-release`, commit the Phase 3 edits as
`🔧 Prepare the <version> release`, open the PR via `/pr`, and let its CI run.
The narrowed docs/config gate usually applies here — the diff is Markdown only —
but `/pr` owns that call; do not pre-empt it.

Merge once green.

**Then wait for `main`'s own run.** `ci.yml` triggers on push to `main` with
`**/*.md` among its paths, so the squashed merge commit gets a CI run of its
own — a *different* commit from the PR head, and the one the tag will point at.
Phase 1's "green on the exact commit being tagged" means this run, not the PR's.
Poll it:

```bash
gh api repos/adamayoung/TMDb/commits/$(git rev-parse HEAD)/check-runs \
  --jq '[.check_runs[] | {name, status, conclusion}]'
```

Red or still running → do not tag. This is the cheapest place in the whole skill
to be patient.

## Phase 8 — Tag

On the merged `main`, at the housekeeping commit:

```bash
git checkout main && git pull
git tag -a <version> -m "<version>"
git push origin <version>
```

Annotated, not lightweight — a release tag should carry an author and a date.

## Phase 9 — Publish

```bash
gh release create <version> --repo adamayoung/TMDb \
  --title "<version>" --notes-file <path> --verify-tag --latest
```

`--verify-tag` refuses to invent a tag that does not exist, which is what turns a
typo into a failed command instead of a phantom release.

Then confirm: print the release URL, and re-read the published notes once to
check nothing was mangled in transit.

## After

Report the tag, the release URL, and what the next window is now open for. If any
`knowledge/next-major.md` entries were deliberately carried forward rather than
shipped, name them — that is the moment someone can still object.

## Failure modes worth knowing

- **A red tag.** Tagging a commit whose CI never passed. Phase 1 exists for this;
  do not skip it because "the PR was green" — the merge commit is a different
  commit, and it gets its own run.
- **Assuming a bad tag is cheap to undo.** Two active tag rulesets cover `~ALL`
  tags with `creation`, `update` and `deletion` rules. The repository-role bypass
  means the owner *can* force it, but nothing here is a casual `git push --delete`
  — and SwiftPM consumers who already resolved the version are unaffected by any
  of it. Get it right going in.
- **A frozen "unreleased".** Skipping Phase 3 ships ADRs and a `next-major.md`
  that insist, inside the release, that the release has not happened.
- **A README nobody can follow.** The `from:` bump is invisible in testing and
  breaks discovery for every new consumer on a major.
- **Version invented from commits.** Deriving the bump from gitmoji rather than
  the CHANGELOG will under-call a major in this repo, roughly every time.
