#!/usr/bin/env python3
"""Fail the lint when a public-extension convenience can witness its requirement.

A default argument *value* is not part of a function's signature for witness
matching. So a convenience in a `public extension` whose parameter list matches
a protocol requirement's after erasing defaults silently becomes that
requirement's default implementation — and a third-party conformer that omits
the requirement compiles, then recurses until the stack overflows, where a
compile error was intended.

Two invariants, both enforced here because neither swiftlint nor a regex can
express them (they need cross-symbol matching):

  1. NO site may have exactly one defaulted parameter. Those are fixable for
     the cost of a single dropped-parameter overload, so there is never a
     reason to leave one.
  2. The number of multi-default sites must equal EXPECTED_MULTI_DEFAULT
     exactly. Those need the power set of overloads to stay call-site
     compatible, so they are deliberately deferred (knowledge/next-major.md).
     The comparison is `!=`, not `>`, for two reasons: a *new* hazard must
     fail, and so must a scan that silently found nothing — a checker whose
     green is indistinguishable from "it never ran" is not a checker.

Lower EXPECTED_MULTI_DEFAULT as they are fixed; at zero, delete this script.
"""

import pathlib
import re
import sys

EXPECTED_MULTI_DEFAULT = 54

SOURCES = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "Sources")

if not SOURCES.is_dir():
    sys.exit("error: %s is not a directory — run this from the package root." % SOURCES)


def closing_paren(text, open_idx):
    depth = 0
    for k in range(open_idx, len(text)):
        if text[k] == "(":
            depth += 1
        elif text[k] == ")":
            depth -= 1
            if depth == 0:
                return k
    return -1


def split_params(inner):
    parts, depth, buf = [], 0, ""
    for ch in inner:
        if ch in "(<[":
            depth += 1
        elif ch in ")>]":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append(buf)
            buf = ""
        else:
            buf += ch
    if buf.strip():
        parts.append(buf)
    return [p for p in parts if p.strip()]


def funcs(block):
    for m in re.finditer(r"\bfunc\s+([A-Za-z0-9_]+)\s*(?:<[^>]*>)?\s*\(", block):
        open_idx = block.index("(", m.end() - 1)
        close_idx = closing_paren(block, open_idx)
        if close_idx < 0:
            continue
        yield m.group(1), split_params(block[open_idx + 1: close_idx]), m.start()


def label(param):
    return param.strip().split(":")[0].split()[0]


def line_of(text, offset):
    return text.count("\n", 0, offset) + 1


requirements, conveniences = {}, []
for path in sorted(SOURCES.rglob("*.swift")):
    text = path.read_text()
    for m in re.finditer(r"^public (protocol|extension) ([A-Za-z0-9_]+)", text, re.M):
        kind, owner = m.group(1), m.group(2)
        end = text.find("\n}\n", m.end())
        block = text[m.end(): end if end > 0 else len(text)]
        for name, params, offset in funcs(block):
            key = (owner, name, tuple(label(p) for p in params))
            if kind == "protocol":
                requirements.setdefault(key, (path, line_of(text, m.end() + offset)))
            else:
                conveniences.append(
                    (key, path, line_of(text, m.end() + offset),
                     sum(1 for p in params if "=" in p)))

hazards = [(k, p, ln, n) for k, p, ln, n in conveniences if n and k in requirements]
single = [h for h in hazards if h[3] == 1]
multi = [h for h in hazards if h[3] > 1]

failed = False

if single:
    failed = True
    print("error: %d public-extension convenience(s) differ from a protocol requirement "
          "ONLY by a default argument, and so become its witness:" % len(single))
    for (owner, name, labels), path, ln, _ in sorted(single, key=lambda h: str(h[1])):
        print("  %s:%d  %s.%s(%s)"
              % (path, ln, owner, name, "".join(l + ":" for l in labels)))
    print("\n  Fix: drop the defaulted parameter instead of defaulting it —")
    print("       `func f() { f(x: nil) }`, not `func f(x: T? = nil) { f(x: x) }`.")
    print("       See knowledge/gotchas.md.")

if len(multi) != EXPECTED_MULTI_DEFAULT:
    failed = True
    print("\nerror: %d multi-default witness sites, expected exactly %d."
          % (len(multi), EXPECTED_MULTI_DEFAULT))
    if len(multi) > EXPECTED_MULTI_DEFAULT:
        print("       A new one was added. Give the convenience a distinct signature, or")
        print("       raise EXPECTED_MULTI_DEFAULT here and record it in "
              "knowledge/next-major.md.")
    else:
        print("       Either some were fixed — lower EXPECTED_MULTI_DEFAULT and update")
        print("       knowledge/next-major.md — or this scan found nothing it should have.")

if failed:
    sys.exit(1)

print("defaulted-witness check: 0 single-default sites, %d deferred multi-default sites "
      "(limit %d)." % (len(multi), EXPECTED_MULTI_DEFAULT))
