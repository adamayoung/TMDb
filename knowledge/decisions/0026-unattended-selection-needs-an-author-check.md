# ADR-0026: An unattended run must not read its authorisation from the work it selected

- **Status:** Accepted (unreleased — tooling only)
- **Date:** 2026-08-20
- **Deciders:** Adam Young

## Context

`/deliver next` lets the delivery pipeline choose its own work: it reads the
project board's `Ready` column, picks a candidate, drafts a plan for it, and —
as `/deliver auto merge next` — carries it to a squash-merge on `main` with no
human in the loop.

Two properties decide whether a candidate may take that unattended path, and
both were parsed out of the **issue body**:

- its `**Breaking class:**` line, which must read `none`;
- whether its fix is *reflexive* — touching `.claude/skills/**`,
  `.claude/agents/**`, `.claude/workflows/**` or `.github/CODE_REVIEW.md` —
  judged from the issue's own fix sketch and the files it names.

Three facts about this repository combine badly with that. It is **public**, so
anyone can open an issue. `/triage-issues` adopts **every** open issue onto the
board's Backlog, so reaching the board is automatic rather than a maintainer's
choice. And `/deliver next` derives its acceptance criteria from the issue's
*Failure scenario* section, so the rubric the work is graded against comes from
the same text.

The result was a self-attesting authorisation: an outsider could write the
defect, the fix sketch, the line certifying it non-breaking, and the criteria
their own change would be graded by. Nothing in the path re-derived any of it
from the code, and nothing checked who wrote it. A security review of PR #474
rated it HIGH with a concrete end-to-end path into `main` of a published
package.

## Decision

**In `merge` mode, a candidate is selectable only if its `author_association`
is `OWNER`, `MEMBER` or `COLLABORATOR` — and the same is required of the
`<!-- triaged: … -->` marker comment the re-verification step relies on.**
Absent or unrecognised counts as untrusted.

`CONTRIBUTOR` is **excluded by name**. GitHub assigns it permanently once an
account has had anything merged, so a one-line typo PR would otherwise buy a
standing credential — an association check that stopped at "has contributed
before" would be bypassable by design rather than by accident.

The check is scoped to `merge` alone, and it **skips** rather than rejects: the
candidate is passed over for this run and left exactly where it sits on the
board, with no comment and no column change.

## Consequences

- `/deliver auto merge next` can only ever unattended-merge work that a
  maintainer wrote. Every outside proposal still gets delivered by
  `/deliver next` and `/deliver auto next` — it simply stops at the
  ready-to-merge gate, which is where a stranger's proposal should stop.
- The gate narrows what `merge` mode can pick. Combined with the Breaking-class
  filter, `auto merge next` will often report "nothing selectable" and do
  nothing, which is the intended failure direction but should be reported
  clearly rather than read as a fault.
- A residual remains and is filed as issue #473: `/triage-issues` still honours
  a `<!-- triaged: … -->` marker from any author, so a forged marker can promote
  an issue to `Ready` with a chosen Priority and Size, unexamined. With this ADR
  in force that is a **board-integrity** problem — it can steer what the
  pipeline picks up next — but no longer a path to a merge.
- The reflexive glob set is now load-bearing for a security property, so it must
  stay identical in its two homes. Both copies name each other and say *change
  both or neither*; see `knowledge/gotchas.md` → *A rule written in two files
  drifts*.

## Alternatives considered

- **Re-derive the facts from the code instead of trusting the body.** Correct in
  principle and far more expensive: judging "is this change breaking?" before
  the change exists means planning it first, and the reflexivity question is
  only answerable from a drafted plan. The backstop already does the latter at
  Phase 10; the author check is what makes the cheap up-front test safe.
- **Drop `merge` from `next` entirely.** Removes the hazard completely, and the
  feature with it. The gate is a narrower cut that keeps the useful case (the
  maintainer's own small, non-breaking, non-reflexive work) intact.
- **Require an explicit label such as `auto-mergeable`.** Equivalent security
  from a different direction, but it adds a labelling step to every issue and
  the label is itself writable by anyone with triage rights. The association is
  already computed by GitHub and cannot be self-assigned.
- **Trust the board, on the grounds that `Ready` implies a maintainer looked.**
  False here: `/triage-issues` runs unattended and adopts orphans automatically,
  so `Ready` is a machine's verdict, not a human's.
