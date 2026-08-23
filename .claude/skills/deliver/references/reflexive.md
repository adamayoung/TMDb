# /deliver — reflexive deliveries (reference)

Read on demand the moment Phase 0 sets `reflexive: true` — a run whose plan
touches the reflexive set (defined in `SKILL.md` Phase 0) is rewriting the
machinery that runs it, and carries these consequences for the rest of the
pipeline.

## 1 — It cannot be dogfooded before merge

The skill registry loaded at session start comes from the **main checkout**,
so your edits are not what executes this run. Verify by reading, and say so in
the PR — never claim a changed skill was exercised end-to-end.

## 2 — Pin verification to the original text

A rewritten rule must not be the thing that grades its own rewrite: Phase 6's
rubric and any review of this diff judge against the ACs and the text as they
stood at Phase 0. (#407 shipped three defects from exactly this: a rewritten
`/deliver` grading itself, ACs that outlived the mechanisms they graded, and a
fan-out shipped as prose in the PR arguing prose isn't a gate.)

## 3 — Sweep the rule's whole footprint, not the file you opened

Changing a rule in a `SKILL.md` is not done until you have grepped its own
`references/`, the skills that delegate to it, and `CLAUDE.md` for the old
wording — a reference is not a copy of the skill, it is where the skill sends
you for the procedure, so a stale one is followed rather than ignored. Grep
for the *old* term, not the new one:

```bash
git diff --name-only origin/main...HEAD | grep '^\.claude/skills/' \
  | sed 's|/[^/]*$||' | sort -u        # every skill dir you touched
grep -rn '<the old wording>' .claude/ CLAUDE.md .github/CODE_REVIEW.md
```

**Re-sweep after every review-loop fix, not just after the first edit.** A
Phase 4 or Phase 5 fix that changes the rule *again* has its own footprint,
and a sweep run against the original change's wording will not find it. This
is how the drift once reached three recurrences: #441–#443 each fixed
`deliver/SKILL.md` and left `deliver/references/worktree-lifecycle.md` — the
file `SKILL.md` points at — still teaching the forbidden `swept:` key, the
superseded "copy the settings file in" procedure, and a run-file schema
missing the field Phase 0 had just been told to write; and the commit that
*fixed* a later delivery's review findings reintroduced the drift into
`.github/ISSUE_FILING.md`, which declares itself authoritative over the
skills, so the stale copy overrode rather than lagged (same shape as #444's
"the rule landed in `/capture-knowledge`; the sweep was scoped to the
instances in front of it"). Sweep per commit-that-changes-a-rule, not per
run.

## 4 — The reviews run even on a markdown diff

Phase 4 and Phase 5 both self-skip on a no-Swift diff — a reflexive delivery
**overrides that**: run `/review-changes` with `force-review` and review the
change on its own terms. The diff being markdown is not evidence it is
low-risk; this is the case #407 shipped three defects through. Phase 10
additionally drops a selection run's `merge` opt-in when `reflexive: true`
(`SKILL.md` Phase 10; rationale in [`next-mode.md`](next-mode.md) §5b).
