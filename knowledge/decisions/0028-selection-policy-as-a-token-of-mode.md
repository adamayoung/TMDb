# ADR-0028: A selection policy is a token of `mode`, not a field beside it

**Status:** Accepted (2026-08-20)
**Context:** issue 481 — `/deliver` gains `issue <n>` alongside `next`

## Context

`/deliver next` selects an issue off the board, claims it, and drafts its own
plan. Four gates key on *"was this a selection run?"* — Phase 1's stranded-claim
sweep, Phase 6's selection gate, Phase 6's `planReview` stop, and Phase 10's
merge-drop — and each did so by testing the run file for `mode: next`.

Adding a second way to select an issue (`issue <n>`, the `explicit` policy)
meant those four predicates had to recognise both. The obvious move, and the one
the original plan took, was a new run-scoped field: `selectionPolicy`, written at
Phase 0 beside `mode`.

That immediately produced a fifth problem. Sixteen run files already existed
under `.git/deliver/`, all carrying `mode: next` and no `selectionPolicy`. A
predicate keyed only on the new field would silently stop matching them — and
the symptom is invisible: an issue stranded in **In progress** forever, in a
column `/triage-issues` is forbidden to touch. So each of the four predicates
would have needed a hand-maintained legacy clause, and the review's own finding
was that two of the four had already been written without one.

## Decision

**No new field. `mode` is a space-separated set drawn from `auto`, `merge`,
`next` and `explicit`, of which `next` and `explicit` are the two
*selection-policy tokens*.** Every gate asks *"does `mode` name a
selection-policy token?"*

`next` remains a policy token rather than being renamed to `top-of-run-list`
precisely so that a pre-change run file satisfies all four predicates **by
construction**.

## Consequences

- **Backward compatibility becomes structural rather than maintained.** There is
  no legacy clause to forget, because the legacy value *is* a current value. This
  was the deciding factor: the alternative required four correct parentheticals
  written by a model, and the first draft got two of them wrong.
- **One less field to write, so one less field to omit.** That matters more than
  it sounds — see below.
- **The vocabulary is slightly impure.** `mode` now mixes invocation keywords
  (`auto`, `merge`) with a resolved policy (`explicit`, which nobody types).
  Accepted: the field was already the parsed invocation rather than the literal
  argument string, and `invocation` records the verbatim text separately.
- **`top-of-run-list` and `explicit` still exist as names**, in prose and in the
  `selection.policy` field. They are how the two policies are *discussed*;
  `mode`'s tokens are how they are *detected*.

### The residual risk, and the second witness

`mode` is written by hand, at Phase 0, by a model. That is a single point of
failure, and it failed on the **first `explicit` run ever performed**: the run
file recorded `mode: "auto"` with a complete `selection` block, which under its
own new predicate was not a selection run at all. Its claim on issue 481 was
unreleasable by any sweep.

So Phase 1, Phase 6's `planReview` stop, and Phase 10 accept **`selection.policy`
as a second witness** — they each read a *completed* `selection` block, so it is
free. Phase 6's **selection gate** deliberately does not: that gate fires
precisely when `selection` is **absent**, so it has no second witness to read and
must stay keyed on `mode` alone.

There is still no gate asserting that *at least one* witness exists, so a run
omitting both is indistinguishable from an ordinary run. Both fields are written
at different phases from different context, so that is a double fault rather than
a single one — noted, not closed.

## Alternatives considered

**A parallel `selectionPolicy` field.** Rejected for the backward-compatibility
burden above. It also fails the discriminator test: a field whose *absence* is
the thing being detected cannot live inside the block whose absence it detects,
and putting it outside duplicates what `mode` already carried.

**Renaming `next` to `top-of-run-list` in `mode`.** Rejected. It would have made
the token set purely policy names, at the cost of breaking every existing run
file and manufacturing exactly the legacy clause this decision avoids.

**A separate `/deliver-issue` skill.** Rejected earlier, before this ADR's scope:
it removes the invocation-grammar ambiguity but duplicates
`next-mode.md`'s verify/claim/release/panel logic into a second file — the drift
class [`gotchas.md`](../gotchas.md) records as this repo's most expensive, and
which recurred four times inside this very delivery. It also leaves both of the
review's blocking findings untouched, since neither depended on the grammar.

**Related:** [ADR-0026](0026-unattended-selection-needs-an-author-check.md) (the
author check the `explicit` policy's merge-refusal path had to re-derive rather
than trust), [ADR-0027](0027-run-list-ordering-in-scripts.md) (the same
"put the rule where it cannot drift" instinct, applied to ordering).
