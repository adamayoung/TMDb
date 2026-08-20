#!/usr/bin/env python3
"""Order `/triage-issues`' Ready set and assemble its canonical run-list line.

`/deliver next` picks its work by parsing ONE line out of the Project status
update `/triage-issues` publishes:

    <!-- run-list: <sha> | 426,437,448,428,454,424,425,427,429,435,467,430 -->

Until this script existed that line was written by the AGENT following
`.claude/skills/triage-issues/SKILL.md` Phase 8. Asking a model to reproduce a
fixed string is the same defect `evidenceDigest` was moved into code to avoid
(`.claude/workflows/triage-issues.js:149-186`): two runs that reach identical
conclusions word them differently, so the consumer's strict parse misses, and
`next` falls back to ordering by board fields — which reproduces two of Phase 6's
four sort rules and silently drops dependency order and contention. Nothing fails
at write time, so the failure is invisible (issue #471).

**This module is the definition of the grammar.** `RUN_LIST_RE` parses what
`build_run_list_line` writes, so the written and parsed forms cannot drift apart.
The prose in `triage-issues/SKILL.md` Phase 8 and
`deliver/references/next-mode.md` §3 quote it by name and must not restate it —
see `knowledge/gotchas.md`, "A rule written in two files drifts, and the copy you
didn't edit is the one that wins".

**Why underscores in the filename**, where every sibling in `Scripts/` uses
hyphens: those are standalone gates that are only ever executed. This one is a
library with a CLI — its tests import it — and `import build-run-list` is not
valid Python.

WHAT IT DOES NOT DO. Phase 5's reconcile — cycle resolution, duplicate
resolution, deciding which edges are discharged — stays with the conductor,
because those are judgement calls needing tool access. This script runs AFTER
that, and treats anything Phase 5 should have resolved as a caller bug it
refuses loudly rather than papering over.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

# The canonical grammar. `<sha>` (7-40 lowercase hex, matching the range
# `/triage-issues` Phase 1 may hand over), then the issue numbers in order,
# comma-separated with NO spaces. Anchored at both ends so a trailing period or
# a wrapping sentence cannot half-match.
#
# The empty-list case is deliberately unmatchable: `<!-- run-list: <sha> | -->`
# would parse as a well-formed run-list containing nothing, which is worse than
# publishing no line at all. An empty Ready set returns `runListLine: None`.
RUN_LIST_RE = re.compile(r"^<!-- run-list: [0-9a-f]{7,40} \| \d+(?:,\d+)* -->$")

HEAD_RE = re.compile(r"^[0-9a-f]{7,40}$")

PRIORITIES = {"P0": 0, "P1": 1, "P2": 2}
SIZES = {"XS": 0, "S": 1, "M": 2, "L": 3, "XL": 4}


class RunListError(Exception):
    """A caller bug: input Phase 5 should have resolved, or a malformed record.

    Never raised for a *legitimate* degenerate case — an empty Ready set and an
    edge onto a closed issue both return normally, with the fact reported.
    """


def _validate(head, ready, closed):
    if not isinstance(head, str) or not HEAD_RE.match(head):
        raise RunListError(
            f"head must be a lowercase git sha (7-40 hex), got {head!r}. "
            "A branch name or an abbreviated-too-far sha writes a line that can never match."
        )
    if not isinstance(ready, list):
        raise RunListError(f"ready must be a list, got {type(ready).__name__}.")
    if not isinstance(closed, (list, tuple, set)):
        raise RunListError(f"closed must be a list, got {type(closed).__name__}.")

    seen = set()
    for index, item in enumerate(ready):
        if not isinstance(item, dict):
            raise RunListError(f"ready[{index}] is not an object: {item!r}.")

        number = item.get("issue")
        # `bool` is an `int` in Python, so exclude it explicitly.
        if not isinstance(number, int) or isinstance(number, bool) or number <= 0:
            raise RunListError(f"ready[{index}].issue is not a positive integer: {number!r}.")
        if number in seen:
            raise RunListError(
                f"ready[{index}] repeats issue #{number}. A duplicate would take two places "
                "in the run-list and make the order ambiguous."
            )
        seen.add(number)

        if item.get("priority") not in PRIORITIES:
            raise RunListError(
                f"#{number}: priority must be one of {sorted(PRIORITIES)}, got {item.get('priority')!r}."
            )
        if item.get("size") not in SIZES:
            raise RunListError(
                f"#{number}: size must be one of {sorted(SIZES, key=SIZES.get)}, got {item.get('size')!r}."
            )

        depends_on = item.get("dependsOn", [])
        if not isinstance(depends_on, list) or any(
            not isinstance(d, int) or isinstance(d, bool) or d <= 0 for d in depends_on
        ):
            raise RunListError(f"#{number}: dependsOn must be a list of positive integers, got {depends_on!r}.")

        files = item.get("filesTouched")
        if files is not None and (not isinstance(files, list) or any(not isinstance(f, str) for f in files)):
            raise RunListError(f"#{number}: filesTouched must be a list of strings, got {files!r}.")


def _resolve_edges(ready, closed):
    """Split each `dependsOn` edge into: kept, discharged, or a caller bug.

    An edge onto a **closed** issue is legitimately discharged — Phase 5 does
    exactly that. An edge onto an issue that is neither Ready nor closed is
    Phase 5's Ready-demotion rule violated ("an issue is `ready` only if every
    issue it `dependsOn` is closed or also becoming Ready ahead of it"), so the
    run-list would otherwise carry an issue whose dependency is not landing.
    """
    in_ready = {item["issue"] for item in ready}
    closed_set = set(closed)

    deps = {}
    discharged = []
    for item in ready:
        number = item["issue"]
        kept = []
        for target in item.get("dependsOn", []):
            if target in in_ready:
                kept.append(target)
            elif target in closed_set:
                discharged.append({"from": number, "to": target})
            else:
                raise RunListError(
                    f"#{number} dependsOn #{target}, which is neither in the Ready set nor "
                    "listed as closed. Either it should not be Ready yet (Phase 5's Ready "
                    "demotion), or #{0} closed and belongs in `closed`.".format(target)
                )
        deps[number] = sorted(set(kept))

    discharged.sort(key=lambda edge: (edge["from"], edge["to"]))
    return deps, discharged


def _assert_acyclic(deps):
    """Kahn's, for detection only. A cycle is Phase 5's job, not this script's.

    SKILL.md Phase 5: "A cycle means at least one edge is wrong — re-read both
    issues rather than picking one to break." Breaking it here would silently
    pick, which is precisely the judgement the conductor is meant to make.
    """
    indegree = {n: len(deps[n]) for n in deps}
    queue = sorted(n for n, d in indegree.items() if d == 0)
    emitted = 0
    while queue:
        node = queue.pop(0)
        emitted += 1
        for other in sorted(deps):
            if node in deps[other]:
                indegree[other] -= 1
                if indegree[other] == 0:
                    queue.append(other)
        queue.sort()
    if emitted != len(deps):
        stuck = sorted(n for n in deps if indegree[n] > 0)
        raise RunListError(
            "dependsOn contains a cycle among issues "
            + ", ".join(f"#{n}" for n in stuck)
            + ". Phase 5 resolves cycles by re-reading both issues; this script will not "
            "pick an edge to break."
        )


def _effective_priorities(items, deps):
    """`min(own priority, best priority over all transitive DEPENDENTS)`.

    This is what makes SKILL.md:207 true — "Rule 1 outranks rule 2: a P2 that
    unblocks a P0 goes first." Plain greedy Kahn's does not do it: it guarantees
    only that a dependency precedes its dependent, so a P2 unblocker with no
    other constraint still sorts behind every independent P1. Promotion has to
    be computed before the sort, not discovered during it.
    """
    own = {n: PRIORITIES[items[n]["priority"]] for n in items}
    dependents = {n: [] for n in items}
    for node, targets in deps.items():
        for target in targets:
            dependents[target].append(node)

    memo = {}

    def resolve(node):
        if node in memo:
            return memo[node]
        best = own[node]
        # Safe to recurse: _assert_acyclic has already run.
        for child in dependents[node]:
            best = min(best, resolve(child))
        memo[node] = best
        return best

    return {n: resolve(n) for n in items}


def _topological_order(items, deps, effective):
    """Kahn's, emitting the best-keyed available node at each step.

    The key is (effective priority, own priority, size, issue number). The issue
    number is load-bearing, not cosmetic: without a total order two runs over the
    same input can emit different lines, which is the defect being fixed.
    """
    remaining = dict(deps)
    satisfied = set()
    order = []

    def key(node):
        item = items[node]
        return (effective[node], PRIORITIES[item["priority"]], SIZES[item["size"]], node)

    while remaining:
        available = [n for n, targets in remaining.items() if set(targets) <= satisfied]
        node = min(available, key=key)
        order.append(node)
        satisfied.add(node)
        del remaining[node]

    return order


def _contends(items, a, b):
    """Two issues contend when their `filesTouched` overlap.

    A **skipped** issue carries no `filesTouched` — its triage marker holds
    `deps=`, `priority` and `size` but not the file list — so it contributes no
    edges. SKILL.md Phase 6 requires this be disclosed rather than presented as
    full coverage; the caller reports it from the `source` it already knows.
    """
    files_a = items[a].get("filesTouched")
    files_b = items[b].get("filesTouched")
    if not files_a or not files_b:
        return False
    return bool(set(files_a) & set(files_b))


def _is_valid_order(order, deps):
    position = {node: index for index, node in enumerate(order)}
    return all(position[target] < position[node] for node in order for target in deps[node])


def _separate_contenders(order, items, deps):
    """One deterministic left-to-right pass; move a non-contender between a pair.

    The primitive is a MOVE (remove and re-insert), not a swap. Swapping the two
    contending issues with each other leaves them adjacent — it does nothing —
    and swapping one of them with a later element reorders that element's own
    neighbourhood, which can break a dependency that a move would not. SKILL.md's
    wording is "when something else can sit between them": insertion.

    Constraints on the element moved in, in the order they are checked:
      * same OWN priority band — rule 2 outranks rule 3, so separating two
        contenders may never promote or demote across priorities;
      * it must not itself contend with the left-hand issue, or the pair is
        merely replaced by a new one;
      * the resulting order must still be a valid topological order.

    Smallest qualifying index wins, one pass, no re-scan — so the output is a
    deterministic function of the input, and the pass is a fixed point on its own
    output. A pair with no qualifying separator is REPORTED, never forced: rule 3
    is conditional ("when something else can sit between them"), so sometimes
    nothing can.
    """
    order = list(order)
    unseparable = []

    index = 0
    while index < len(order) - 1:
        left, right = order[index], order[index + 1]
        if _contends(items, left, right):
            for candidate_index in range(index + 2, len(order)):
                candidate = order[candidate_index]
                if PRIORITIES[items[candidate]["priority"]] != PRIORITIES[items[right]["priority"]]:
                    continue
                if _contends(items, left, candidate):
                    continue
                moved = list(order)
                moved.insert(index + 1, moved.pop(candidate_index))
                if _is_valid_order(moved, deps):
                    order = moved
                    break
            else:
                unseparable.append([left, right])
        index += 1

    return order, unseparable


def _deps_outrank_priority(items, deps):
    """Edges where a lower-priority issue legitimately precedes a higher one.

    SKILL.md Phase 6: "Say so explicitly in the run-list when it happens, or it
    reads as a mis-sort." Returned as structured pairs so Phase 8 writes the
    prose and this module does not.
    """
    pairs = [
        {"before": target, "after": node}
        for node in sorted(deps)
        for target in deps[node]
        if PRIORITIES[items[target]["priority"]] > PRIORITIES[items[node]["priority"]]
    ]
    pairs.sort(key=lambda pair: (pair["before"], pair["after"]))
    return pairs


def build_run_list_line(head, ordered):
    """Assemble the canonical run-list line. This is the grammar's definition.

    Paste the result verbatim; never reword, prettify, annotate or wrap it.
    """
    return "<!-- run-list: {0} | {1} -->".format(head, ",".join(str(n) for n in ordered))


def build(head, ready, closed=()):
    """Order the Ready set and build its run-list line.

    `ready` elements use `triage-issues.js`' own `VERDICT_SCHEMA` field names
    (`issue`, `priority`, `size`, `dependsOn`, `filesTouched`) so a freshly
    triaged verdict is passed through untouched — the caller re-shaping records
    by hand would reintroduce, at the input, exactly the transcription risk this
    script removes at the output.
    """
    _validate(head, ready, closed)

    if not ready:
        return {
            "head": head,
            "ordered": [],
            "runListLine": None,
            "note": "Ready set is empty — no run-list line published this run.",
            "depsOutrankPriority": [],
            "dischargedEdges": [],
            "unseparableContention": [],
        }

    items = {item["issue"]: item for item in ready}
    deps, discharged = _resolve_edges(ready, closed)
    _assert_acyclic(deps)

    effective = _effective_priorities(items, deps)
    ordered = _topological_order(items, deps, effective)
    ordered, unseparable = _separate_contenders(ordered, items, deps)

    return {
        "head": head,
        "ordered": ordered,
        "runListLine": build_run_list_line(head, ordered),
        "note": "",
        "depsOutrankPriority": _deps_outrank_priority(items, deps),
        "dischargedEdges": discharged,
        "unseparableContention": unseparable,
    }


def main():
    """Read `{head, ready, closed}` as JSON from a file argument or stdin."""
    source = Path(sys.argv[1]).read_text(encoding="utf-8") if len(sys.argv) > 1 else sys.stdin.read()
    try:
        payload = json.loads(source)
    except json.JSONDecodeError as error:
        print(f"build-run-list: input is not valid JSON: {error}", file=sys.stderr)
        sys.exit(1)

    if not isinstance(payload, dict):
        print("build-run-list: input must be a JSON object with `head` and `ready`.", file=sys.stderr)
        sys.exit(1)

    try:
        result = build(payload.get("head"), payload.get("ready", []), payload.get("closed", []))
    except RunListError as error:
        print(f"build-run-list: {error}", file=sys.stderr)
        sys.exit(1)

    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
