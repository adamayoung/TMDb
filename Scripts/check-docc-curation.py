#!/usr/bin/env python3
"""Fail the lint when a public service method is missing from its DocC page.

`build-docs` cannot catch this. DocC emits diagnostics for *broken* and
*ambiguous* symbol links, so `--warnings-as-errors` catches a curation line
pointing at nothing — but an uncurated symbol is silently folded into a default
topic group with no diagnostic at all. So a forgotten `- ``method(a:b:)``` line
ships green, and the only signal is a reader noticing the method is filed under
"Instance Methods" instead of the topic it belongs to.

That gap stopped being theoretical when the power-set rewrite (issue #431)
added 306 public overloads and 306 curation lines in one sweep. This check ran
for the first time against that tree and immediately found two *pre-existing*
omissions on `PersonService`, which is the argument for keeping it.

Scope: protocols under Sources/TMDb/Domain/Services that already have a page in
TMDb.docc/Extensions. A protocol with no page is not curated at all, which is a
separate (deliberate) choice and not this script's business.
"""

import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else ".")
SOURCES = ROOT / "Sources/TMDb"
EXTENSIONS = SOURCES / "TMDb.docc/Extensions"

if not EXTENSIONS.is_dir():
    sys.exit("error: %s is not a directory — run this from the package root." % EXTENSIONS)


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


def label(param):
    return param.strip().split(":")[0].split()[0]


declared = {}
for path in sorted(SOURCES.rglob("*.swift")):
    text = path.read_text()
    for m in re.finditer(r"^public (protocol|extension) ([A-Za-z0-9_]+)", text, re.M):
        owner = m.group(2)
        end = text.find("\n}\n", m.end())
        block = text[m.end(): end if end > 0 else len(text)]
        for fm in re.finditer(r"\bfunc\s+([A-Za-z0-9_]+)\s*(?:<[^>]*>)?\s*\(", block):
            open_idx = block.index("(", fm.end() - 1)
            close_idx = closing_paren(block, open_idx)
            if close_idx < 0:
                continue
            params = split_params(block[open_idx + 1: close_idx])
            sig = "%s(%s)" % (fm.group(1), "".join(label(p) + ":" for p in params))
            declared.setdefault(owner, set()).add(sig)

missing = []
checked = 0
for page in sorted(EXTENSIONS.glob("*.md")):
    owner = page.stem
    if owner not in declared:
        continue
    # A link may carry a disambiguation suffix — ``f(a:)->T`` — where two symbols
    # share a name and labels, so compare on the part before it.
    curated = {re.split(r"->|-(?=[0-9a-f]{6,}$)", link)[0]
               for link in re.findall(r"``([^`]+)``", page.read_text())}
    for sig in sorted(declared[owner]):
        checked += 1
        if sig not in curated:
            missing.append((owner, sig, page.name))

if missing:
    print("error: %d public method(s) are absent from their DocC Extensions page:"
          % len(missing))
    for owner, sig, page in missing:
        print("  %s.%s   (add to %s)" % (owner, sig, page))
    print("\n  DocC auto-curates an uncurated symbol into a default topic group")
    print("  WITHOUT a diagnostic, so build-docs cannot catch this. Add a")
    print("  `- ``%s``` line under the right topic." % missing[0][1])
    sys.exit(1)

if not checked:
    sys.exit("error: matched no public methods against any Extensions page — the "
             "scan is broken, so this green means nothing.")

print("docc curation check: %d public method(s) across %d page(s), all curated."
      % (checked, len({p.stem for p in EXTENSIONS.glob('*.md')} & set(declared))))
