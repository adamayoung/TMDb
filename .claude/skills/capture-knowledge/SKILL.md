---
name: capture-knowledge
description: Capture durable, project-specific learnings from the work just done into the knowledge/ base — gotchas, implementation quirks, things looked up or web-searched, live-API behaviours, and design decisions (as ADRs). Use before opening a PR (it runs automatically in /deliver), or any time you've learned something worth remembering. Records only non-obvious, reusable facts; skips anything already in the repo, CLAUDE.md, or git history.
---

# Capture Knowledge

Fold what you just learned into the committed knowledge base at `knowledge/`, so a
future session (or contributor) doesn't have to re-learn or re-discover it. Run
this **before a PR** — in `/deliver` it runs automatically pre-PR, so the
notes land in the same PR as the change.

## What to capture (be selective)

Record only **durable, project-specific, non-obvious** facts — the test is "would
a future me waste time without this?":

- **Gotchas / quirks** → `knowledge/gotchas.md` — a trap you hit, a tooling
  surprise, anything that needed a **web search or doc lookup** to resolve.
- **Live-API behaviours** → `knowledge/tmdb-api-notes.md` — a nullable/absent
  field, an undocumented response shape, an enum value the docs omit.
- **Design decisions** → a new **ADR** in `knowledge/decisions/` (next number —
  take it from [`decisions/README.md`](../../../knowledge/decisions/README.md)'s
  index, not a directory listing), using `decisions/0000-template.md`. Any
  non-obvious choice and its rationale — why this approach over the
  alternatives. Add the new row to that index.
- **Deferred breaking changes** → `knowledge/next-major.md` — any fix
  rejected or deferred *because* it is breaking. The skill-improvement log
  remembers the "no"; this file is what makes the deferred "yes" resurface
  at the next major. **Reconcile its status line whenever you add an entry:**
  it states which major window is open, and an entry filed against a window
  that already shipped is invisible at exactly the moment it should fire. A
  window is open until the version is **tagged** — an unreleased `CHANGELOG`
  section is not a release (`git tag --list | sort -V | tail -1`).

## What NOT to capture

Mirror the discipline of a good memory — don't record:

- Anything already in the code, `CLAUDE.md`, the DocC docs, or git history.
- Facts that only mattered to this one task and won't recur.
- Restatements of the obvious. If asked to record something obvious, capture the
  *non-obvious* part (what surprised you) or skip it.

Quality over volume: a few high-signal entries beat a long dump.

## When an entry records a count, ask what enforces it

If a candidate entry states a **known-remaining defect count** — "54 sites still
do X", "3 models still decode Y unsafely" — stop and ask the follow-up:
**"what fails if that number changes?"** A number in a markdown file is a
promise with nothing behind it; it silently goes stale as sites are fixed *or*
regressed, and the two cancel out.

Prefer a committed check with an **explicit set**, not a count (an exact
allowlist so a fix and a regression can't cancel, and an empty scan can't pass),
wired into **both** `make lint` and CI — no workflow runs `make`, so one alone
is invisible. `Scripts/check-defaulted-witnesses.py` is the worked example. If a
guard isn't worth building, say so in the entry, so the number reads as an
observation rather than an invariant.

## Steps

1. **Start from the candidates list, if one exists.** If the caller passed a
   **knowledge-candidates** list as the argument (`$ARGUMENTS` below — `/deliver`
   pastes its ledger list here), use that as your input — that's the reliable
   source, jotted while the learnings were fresh, and it reaches you intact even
   if the caller's context was compacted. Otherwise, reconstruct candidates by
   reviewing the work just done — the diff, the dead-ends, the things you looked
   up, the decisions you made.
2. **Filter** against "What NOT to capture". Drop the rest.
3. **Check for duplicates** — skim the relevant `knowledge/` file; **update** an
   existing entry rather than adding a near-duplicate.
4. **Write each entry** in the right file:
   - Gotchas / API notes: a short dated subsection (`### <title>`), newest at the
     top, under the right heading. Date it with today's date.
   - **Cite the PR that did the work, not the issue it came from.** A bare
     `#NNN` is ambiguous — this repo's numbers interleave issues and PRs, so
     `(#432)` and `(#417)` look identical and only one is the change. Take the
     number from the branch's own PR; if it doesn't exist yet, leave a
     placeholder and backfill it. Name the issue only when the issue itself is
     the subject, and then say "issue #NNN" in words. (See
     [`knowledge/README.md`](../../../knowledge/README.md) → *How to use it*.)
   - Decisions: copy `decisions/0000-template.md` to
     `decisions/NNNN-<kebab-title>.md` (next free number), fill in Status / Date /
     Context / Decision / Consequences / Alternatives. Cross-link related ADRs.
5. **Retire what the diff invalidates — sweep by citation, not by
   neighbourhood.** The base is a **cache of current truths, not an archive**
   (git history is the archive — see
   [`knowledge/README.md`](../../../knowledge/README.md) → *Maintenance &
   retention*). Staleness is usually caused by the very change you are
   capturing for, so find it from the diff:

   1. List the infrastructure files this change touched:

      ```bash
      git diff --name-only origin/main...HEAD | \
        grep -E '^(Makefile|Package\.swift|Package\.resolved|\.github/workflows/|\.claude/)'
      ```

   2. For each hit, grep **all of `knowledge/`** (not just the file you are
      writing to) for entries citing that file, its targets, or its pinned
      values — e.g. `grep -n 'Makefile\|make ci\|TEST_TARGET' knowledge/*.md`,
      `grep -n 'ci\.yml\|Xcode_[0-9]' knowledge/*.md`. Test-target lists,
      pinned tool/Xcode versions, `SWIFTCI_DOCC`, scratch paths, and workflow
      step names are the usual casualties. If the change renames or removes a
      `knowledge/` entry heading, also grep `.claude/` and `CLAUDE.md` for
      citations of the old title — skills cite gotchas by title.
   3. **Read every citing entry and reconcile it**: still true → leave it;
      partly true → rewrite it in the present tense; no longer true → delete
      it. **Never append an "Update:" / "Resolved in #NNN" note to a stale
      entry — rewrite or delete it.** An entry that narrates its own history
      contradicts itself within weeks (this is exactly how the `.docc` gotcha
      decayed across #396–#402).
   4. Report the sweep as one line:
      `swept: <infra files touched> → <entries rewritten/deleted | none cited>`.
      No infra files in the diff → `swept: n/a`, and fall back to scanning
      the neighbouring entries of any knowledge file you edited.
6. **Keep it tidy by hand** — blank lines around headings/lists/code fences, a
   language on every fence, one `#` H1 per file. Note `knowledge/` is **not** in
   the `make lint-markdown` scope (which covers `README.md`, `CLAUDE.md`,
   `**/*.docc/**`, and `.claude/**`), so there's no CI gate on these files —
   readability is on you. Aim for ~80-col prose; long `jq`/URL lines are fine.
7. **Update `knowledge/README.md`** only if you added a new file or category (the
   per-entry index inside each file is enough otherwise).

## Return

Report concisely what you captured: each entry → which file (and ADR number for
decisions), and note anything you deliberately skipped as not durable. If nothing
met the bar, say so plainly — capturing nothing is a valid outcome.

Arguments: $ARGUMENTS
