# ADR-0024: Keep the defaulted-witness guard, as a two-way completeness oracle

- **Status:** Accepted (in 20.0.0, unreleased)
- **Date:** 2026-08-14
- **Deciders:** Adam Young

## Context

`Scripts/check-defaulted-witnesses.py` was written for the 2026-08-07 sweep
(PR #410) as an **allowlist**: it failed on any single-default witness, and
required the multi-default sites to match a `DEFERRED` set exactly. Its own
docstring said that at empty — once every site was fixed — the script and its
two invocations should be deleted.

Issue #431 emptied it. That forced the question the docstring had already
answered, and answering it again produced a different answer.

Two properties of the fix are what changed the calculus. First, the power-set
rewrite replaces each defaulted convenience with 2ⁿ−1 overloads, and **every
gate in the repo is deletion-side**: once the defaulted convenience is gone and
its allowlist line removed, nothing notices whether 7 replacements were written
or 6. A missing one is a *silent source break* for any caller using that
argument combination, and it passes lint, build, test and CI. Second, the
information the check would need to notice — which parameters each site
defaulted — **only exists until the rewrite deletes it**.

There was also a live counter-example to "the hazard is handled": the widened
detector immediately found `MovieService.releaseDates(forMovie:)`, a
`public extension` twin of its own requirement whose body called itself. It had
been in the tree since PR #259 and survived #410's sweep, because the old
`hazards` filter tested the default *count* for truthiness and so skipped a
duplicate with no defaults at all.

## Decision

**Keep the script**, and make it check both directions.

One table, `SITES`, holds the whole census — each site's `(protocol, method,
argument labels)` mapped to the labels that carried defaults — derived
mechanically from the tree, never typed by hand. `REWRITTEN` names the sites
already replaced, so fixing one is a one-line addition and the label tuples are
never retyped. Four invariants:

1. **No witness.** A convenience sharing a requirement's argument labels is a
   hazard **at any default count, including zero**.
2. **Pending sites stay honest.** A not-yet-rewritten site must still be
   present and still carry exactly the defaults recorded for it — so the tuple a
   later rewrite depends on has been machine-checked on every run up to the
   moment the tree stops being able to prove it.
3. **Rewritten sites expose exactly their power set** — missing means a source
   break; extra means the recorded tuple understates what the site defaulted.
4. **The census is closed** (`TOTAL_SITES`, `TOTAL_OVERLOADS`), so removing an
   entry cannot silently disable its own guard.

A `SELF_TEST` fixture exercises the detector, the default detection and the
subset generator over planted input on every run.

The same reasoning produced a sibling, `Scripts/check-docc-curation.py`: 306
curation lines were added by this change, and `build-docs` cannot see a missing
one.

## Consequences

- The guard now prevents the hazard from *returning* — which is the durable
  value, since the idiom was written 91 times by habit and the census only ever
  counted what already existed.
- Invariant 2 is spent. With every site rewritten there is no pending entry
  left, so the recorded tuples are frozen data the tree can no longer
  corroborate; invariants 3 and 4 are what audit them from then on.
- Adding a service method with defaults that match a requirement's labels now
  fails `make lint`. That is the point, but it is a new way to be stopped.
- The checkers share parsing conventions with each other and with the Swift
  they read; a Swift syntax the regexes do not model (a macro-generated member,
  say) is invisible to both.

## Alternatives considered

- **Delete at empty, per the original docstring.** Rejected. It gives up the
  only automated protection against reintroducing a hazard that was written 91
  times, and the deletion argument — that an always-empty allowlist makes green
  indistinguishable from a scan that matched nothing — is answered by the
  self-test rather than by removal.
- **Keep the allowlist shape with `DEFERRED = frozenset()`.** Rejected once the
  deletion-side asymmetry was clear: it would have gone on checking only that
  witnesses were absent, never that the replacements existed.
- **A count floor** (`assert len(requirements) > 0`) as the canary. Rejected:
  requirements and conveniences both stay non-zero when default *detection*
  breaks, which is the failure that actually matters. Only running the machinery
  over known inputs distinguishes those.
- **Derive "the parameters this site cannot drop" from `SITES`** when auditing
  invariant 3. Tried, and wrong in an instructive way: it made the check
  self-consistent with a corrupted table, because the overloads that would
  expose an understated tuple are exactly the ones such a filter discards.
  Overloads are attributed to the site with the smallest label set containing
  them instead — and only zero-default declarations count, or a *defaulted*
  helper sharing a label set (the synchronous paginating
  `allTrending(inTimeWindow:language:)`) stands in for a missing overload.

Related: [ADR-0023](0023-python-strict-parser-for-fixture-hygiene.md) (the same
independent-parser-in-`make lint`-and-CI shape),
[ADR-0005](0005-authenticated-session-additive-overloads.md) (why these
protocols grow by extension rather than by new requirements), and
`knowledge/gotchas.md` § *A protocol-extension convenience that differs only by
a default argument becomes the requirement's witness*.
