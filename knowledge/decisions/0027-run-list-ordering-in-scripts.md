# ADR-0027: Compute the triage run-list in `Scripts/`, not in a workflow

- **Status:** Accepted (unreleased — tooling only)
- **Date:** 2026-08-20
- **Deciders:** Adam Young

## Context

`/triage-issues` Phase 8 publishes one canonical line to a Project status update:

```text
<!-- run-list: <sha> | 426,437,448,428,454,424,425,427,429,435,467,430 -->
```

`/deliver next` parses **that line and nothing else** to choose its work. Until
now the line was written by the agent from a prose spec, and the ordering behind
it was computed by the agent too. That is the defect `evidenceDigest` already
moved into code (`.claude/workflows/triage-issues.js`): an LLM asked to reproduce
a fixed string words it differently each run, so the consumer's strict parse
misses, `next` falls back to board fields, and the dependency and contention
ordering is lost — silently, because nothing fails at write time (issue #471).

Two constraints shaped where the fix could live.

**The sort cannot fold into the existing fan-out.** `triage-issues.js` returns
one verdict per issue; Phase 5's *reconcile* then runs — cycle resolution
("re-read both issues rather than picking one to break"), duplicate resolution,
and discharging edges onto closed issues. Those are judgement calls needing tool
access the script does not have, and they change the Ready set. So the ordering
must run **after** the script returns: it is necessarily a second invocation.

**A workflow script cannot be imported by a test.** Workflow scripts use a
top-level `return` and harness globals (`args`, `agent`, `log`), so they are not
ES modules. Putting deterministic, unit-testable logic there would have forced a
wrapper shim and a main-guard test hook — and left open whether a zero-agent
`Workflow` run is even treated as a success.

## Decision

Put the ordering and the grammar in **`Scripts/build_run_list.py`**, invoked
synchronously from Phase 6 with a JSON file, and have Phase 8 paste the returned
`runListLine` field verbatim.

`.claude/workflows/` is the **agent-orchestration** namespace and `Scripts/` the
**deterministic** one — a distinction `.claude/skills/review-changes/SKILL.md`
already draws. A pure sort belongs in the second. `python3` matches the five
existing `Scripts/` checkers and is already a repo prerequisite, so no new
toolchain enters `make lint` or CI, and `Scripts/**` is already in both CI paths
filters.

The module exports `RUN_LIST_RE` alongside `build_run_list_line`, so the written
form and the parsed form are defined together and cannot drift apart. Phase 6 and
Phase 8 state each rule's *intent* and delegate the definition to the script —
the same single-ownership rule `/triage-issues` already applies to its rubrics.

## Consequences

**The ordering is now testable, and two defects fell out of testing it that had
been specified wrongly in prose for as long as the prose existed:**

- *A topological sort does not satisfy "a P2 that unblocks a P0 goes first."*
  Precedence is not promotion — greedy Kahn's keyed on own priority emits an
  independent P1 before a P2 unblocker. The script computes an **effective
  priority** (`min(own, best over transitive dependents)`) before sorting.
- *Separating two contending issues by swapping them is a no-op* — they stay
  adjacent. The primitive is a **move**, and its priority-band check must cover
  the whole **jumped range**, not just the new neighbour, or the separator
  overtakes a higher-priority issue with no dependency edge to disclose it.

Ordering is now a total function of its input: the final tiebreak is the issue
number, so the same Ready set always yields a byte-identical line regardless of
the order the conductor assembled it in.

Errors fail loudly instead of degrading. A cycle, an edge onto an issue that is
neither Ready nor declared closed, or a malformed record exits non-zero; Phase 6
says to fix the input and re-invoke, and **never** to hand-write the line. An
empty Ready set returns no line rather than one with an empty issue list, which
would parse as a well-formed run-list containing nothing.

The grammar now lives in a builder plus one prose quotation in
`next-mode.md` §3 — two places, not the three the first design would have had,
because Phase 8 names a *field* rather than a format. The remaining pair is held
together by a test that reads the prose off disk (see `gotchas.md`, "A rule
written in two files drifts").

`Scripts/build_run_list.py` uses **underscores** where its five siblings use
hyphens. The siblings are only ever executed; this one is imported by its tests,
and `import build-run-list` is not valid Python.

Costs: one more `make lint` prerequisite and one more CI `Lint` step, and the
`Lint` job's `Checkout` had to widen from `swift` to `swift || markdown` so the
anti-drift cases can read the skill prose. The conductor must still assemble the
script's input — Phase 3's marker *parsing* remains prose, so `buildMarker` still
has no counterpart in code.

## Alternatives considered

**A `mode` switch on `.claude/workflows/triage-issues.js`.** One file would own
both fixed formats. Rejected: its `meta` declares `model: 'opus'` and a `Triage`
phase that a zero-agent invocation makes untrue, its validation prelude is shaped
for the fan-out, and the testability problem above remains.

**A second workflow script, `.claude/workflows/triage-run-list.js`.** The
original plan. Rejected in review: it manufactures a test shim, a main-guard, and
an unresolved question about zero-agent workflow runs — none of which exist for
an ordinary module.

**Leaving the sort in the conductor and mechanising only the line.** Rejected:
the line would then be a faithful rendering of an ordering nothing checks, which
moves the drift one step back rather than removing it.

## Related

- [0016](0016-panel-jurors-and-workflows-directory.md) — why `.claude/workflows/`
  exists and what belongs there.
- [0023](0023-python-strict-parser-for-fixture-hygiene.md) — the same choice of
  an independent Python checker over an in-language test.
- [0026](0026-unattended-selection-needs-an-author-check.md) — the authorisation
  gate that sits upstream of this ordering, in `next-mode.md` §2.
