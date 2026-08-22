#!/usr/bin/env python3
"""Read and update /deliver's durable run file — and PROVE every write landed.

The run file lives at `<main checkout>/.git/deliver/<id>.json` (ADR-0015):
deliberately outside the working tree, so it can never enter a diff and it
survives `ExitWorktree(remove)`. But a worktree-isolated session's Bash guard
refuses commands it cannot statically prove stay inside the worktree, and
`.git/` is outside it BY DESIGN — so ad-hoc run-file writes fight the guard,
and some refusals are SILENT: a `python3 - <<EOF` heredoc rewriting the file
produced no output, no error and no write (PR #474), and in the #493 delivery
two refused writes went unnoticed and the conductor certified to the auto-mode
juror panel a revision that was not on disk.

This script is the sanctioned route (skill-improvement-log 2026-08-22 decision
on the 2026-08-21/#490 and 2026-08-12/#440 entries). Two properties carry the
whole value:

  1. INVOKABLE PAST THE GUARD. `python3 Scripts/deliver-runfile.py set <literal
     path> <path> <value>` is a single-purpose command with fully literal
     arguments — the shape the guard accepts — and the out-of-worktree write
     happens inside the interpreter, where no static check applies.

  2. IT VERIFIES ITS OWN POSTCONDITION. After writing, it re-opens the file
     fresh from disk and asserts the value at the path is the one requested;
     a mismatch is a loud non-zero exit, never a shrug. A run-file write that
     reports nothing has told you nothing (`knowledge/gotchas.md` → the silent
     heredoc refusal), and CLAUDE.md's probe rule applies to state writers
     too: a script must verify the state it claims to have left.

Design rules, learned the hard way elsewhere in Scripts/:

  * REFUSE a missing intermediate path segment rather than creating it. A typo
    (`deliverable.0.stamps`, `stamps.reviewedclean`) that silently grows a
    parallel tree is a false green: the write "succeeds" while every later
    reader — Phase 6's gate included — sees the old value. Only the FINAL
    segment may be new, because schema fields legitimately appear over a run's
    life (`claimHandedBack`, `locationDeviation`).

  * The write is atomic (temp file + os.replace in the same directory), so a
    crash mid-write can never leave a half-JSON run file for the next phase's
    hard stop to trip over.

Usage:
  deliver-runfile.py get <file> <dotted.path>
  deliver-runfile.py set <file> <dotted.path> <value>

Paths are dot-separated; an integer segment indexes an array
(`deliverables.0.stamps.reviewedClean`). `set` parses <value> as JSON first
(`null`, `true`, `42`, `{"a":1}`, `["x"]` arrive typed) and falls back to a
bare string — pass explicit JSON (`'"null"'`) to force a string that would
otherwise parse.

Exit codes: 0 ok · 1 usage/file/path error (nothing written) · 2 postcondition
failed (the write did NOT land — treat as a hard stop, never assume it did).
"""

from __future__ import annotations

import json
import os
import sys
import tempfile
from pathlib import Path


def parse_value(raw: str):
    """JSON first, bare string as the fallback."""
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return raw


def split_path(dotted: str) -> list[str]:
    segments = dotted.split(".")
    if not dotted or any(s == "" for s in segments):
        fail(f"invalid path {dotted!r} — empty segment")
    return segments


def fail(message: str, code: int = 1) -> None:
    print(f"deliver-runfile: {message}", file=sys.stderr)
    sys.exit(code)


def load(file: Path) -> dict:
    if not file.is_file():
        fail(f"{file} does not exist — Phase 0 writes the initial file before EnterWorktree")
    try:
        with open(file, encoding="utf-8") as handle:
            return json.load(handle)
    except json.JSONDecodeError as error:
        fail(f"{file} is not valid JSON ({error}) — refusing to touch it")
    raise AssertionError("unreachable")


def descend(node, segments: list[str], dotted: str, *, for_write: bool):
    """Walk to the PARENT of the final segment, refusing missing intermediates.

    Returns (parent, final_segment). For arrays the segment must be a valid
    in-range integer — a write never grows or creates an array through a path.
    """
    walked: list[str] = []
    for segment in segments[:-1]:
        walked.append(segment)
        where = ".".join(walked)
        if isinstance(node, list):
            index = array_index(segment, node, where)
            node = node[index]
        elif isinstance(node, dict):
            if segment not in node:
                fail(f"path segment {where!r} does not exist — refusing to create intermediate structure (a typo'd path silently writing a parallel tree is the false green this script exists to prevent)")
            node = node[segment]
        else:
            fail(f"path segment {where!r} is a {type(node).__name__}, not an object or array — cannot descend into it")
    final = segments[-1]
    if isinstance(node, list):
        array_index(final, node, dotted)
    elif not isinstance(node, dict):
        fail(f"parent of {dotted!r} is a {type(node).__name__}, not an object or array")
    elif not for_write and final not in node:
        fail(f"path {dotted!r} does not exist in the file")
    return node, final


def array_index(segment: str, node: list, where: str) -> int:
    try:
        index = int(segment)
    except ValueError:
        fail(f"path segment {where!r} addresses an array — expected an integer index, got {segment!r}")
    if not 0 <= index < len(node):
        fail(f"index {index} at {where!r} is out of range for an array of {len(node)}")
    return index


def read_at(data, segments: list[str], dotted: str):
    parent, final = descend(data, segments, dotted, for_write=False)
    return parent[int(final)] if isinstance(parent, list) else parent[final]


def write_file(file: Path, data: dict) -> None:
    """Atomic replace in the file's own directory."""
    descriptor, temp_path = tempfile.mkstemp(dir=file.parent, prefix=file.name, suffix=".tmp")
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as handle:
            json.dump(data, handle, indent=2)
            handle.write("\n")
        os.replace(temp_path, file)
    finally:
        if os.path.exists(temp_path):
            os.unlink(temp_path)


def command_get(file: Path, dotted: str) -> None:
    value = read_at(load(file), split_path(dotted), dotted)
    print(json.dumps(value))


def command_set(file: Path, dotted: str, raw: str) -> None:
    value = parse_value(raw)
    segments = split_path(dotted)
    data = load(file)
    parent, final = descend(data, segments, dotted, for_write=True)
    if isinstance(parent, list):
        parent[int(final)] = value
    else:
        parent[final] = value
    write_file(file, data)

    # The postcondition: re-read from DISK, not from the object just mutated in
    # memory — the in-memory copy is exactly what a suppressed write leaves
    # looking correct.
    landed = read_at(load(file), segments, dotted)
    if landed != value:
        fail(
            f"POSTCONDITION FAILED — wrote {dotted} = {json.dumps(value)} but the file "
            f"on disk holds {json.dumps(landed)}. The write did NOT land; treat this as "
            "a hard stop, never as done.",
            code=2,
        )
    print(f"verified: {dotted} = {json.dumps(landed)} in {file}")


def main(argv: list[str]) -> None:
    if len(argv) >= 3 and argv[0] == "get" and len(argv) == 3:
        command_get(Path(argv[1]), argv[2])
    elif len(argv) == 4 and argv[0] == "set":
        command_set(Path(argv[1]), argv[2], argv[3])
    else:
        fail("usage: deliver-runfile.py get <file> <dotted.path> | set <file> <dotted.path> <value>")


if __name__ == "__main__":
    main(sys.argv[1:])
