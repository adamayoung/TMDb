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

Two things stop this from becoming a checker whose green means nothing, both
learned from its sibling `check-defaulted-witnesses.py`:

  * `EXPECTED_PAGES` closes the census. Without it, deleting an Extensions page
    would drop every method it covered out of the scan and still print a
    cheerful summary — the coverage would shrink silently, which is precisely
    the hazard this script exists to prevent, one level up.
  * `SELF_TEST` runs the extractor over planted input with one curated and one
    uncurated method. The parsing here is shared with its sibling, and a
    regression in it would otherwise look identical to a clean tree.
"""

import collections
import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else ".")
SOURCES = ROOT / "Sources/TMDb"
EXTENSIONS = SOURCES / "TMDb.docc/Extensions"

# Every protocol with a curated page, as of 2026-08-14. A page that disappears
# takes its methods out of the scan with it, so the set is checked rather than
# discovered.
EXPECTED_PAGES = frozenset({
    "AccountService", "AuthenticationService", "CertificationService",
    "ChangesService", "CollectionService", "CompanyService",
    "ConfigurationService", "CreditService", "DiscoverService", "FindService",
    "GenreService", "GuestSessionService", "ImageService", "KeywordService",
    "ListService", "MovieService", "NetworkService", "PersonService",
    "ReviewService", "SearchService", "TVEpisodeGroupService",
    "TVEpisodeService", "TVSeasonService", "TVSeriesService",
    "TrendingService", "V4AuthenticationService", "V4ListService",
    "WatchProviderService",
})

SELF_TEST_SWIFT = '''
public protocol CanaryService {
    func curated(alpha: String?) async throws -> Int
    func twin(gamma: Int) async throws -> Int
}

public extension CanaryService {
    func curated() async throws -> Int { try await curated(alpha: nil) }

    func forgotten(beta: Int) async throws -> Int { beta }

    func twin(gamma: Int) -> String { "\\(gamma)" }
}
'''

# Curates `curated` fully, `forgotten` not at all, and only one of the two
# `twin(gamma:)` overloads — so the fixture exercises both a plain omission and
# the overload-pair case a set-based comparison cannot see.
SELF_TEST_PAGE = """# ``CanaryService``

## Topics

### Everything

- ``curated(alpha:)``
- ``curated()``
- ``twin(gamma:)->Int``
"""


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


def public_methods(text):
    """owner -> Counter of "name(a:b:)" for every public method declared.

    A *count*, not a set: two overloads can share a name and argument labels
    while differing by return type, and each needs its own curation line.
    `TrendingService.allTrending(inTimeWindow:language:)` is exactly that — a
    synchronous paginating overload alongside the async one — and DocC will not
    report the gap either, because with only one of the pair curated the
    surviving disambiguated link resolves cleanly.

    An extension may be spelled without `public` and still expose a public
    member, so the access level is taken from whichever of the two carries it.
    """
    found = {}
    for m in re.finditer(r"^(public )?(protocol|extension) ([A-Za-z0-9_]+)", text, re.M):
        is_public, owner = bool(m.group(1)), m.group(3)
        end = text.find("\n}\n", m.end())
        block = text[m.end(): end if end > 0 else len(text)]
        for fm in re.finditer(r"(public\s+)?\bfunc\s+([A-Za-z0-9_]+)\s*(?:<[^>]*>)?\s*\(", block):
            if not (is_public or fm.group(1)):
                continue
            open_idx = block.index("(", fm.end() - 1)
            close_idx = closing_paren(block, open_idx)
            if close_idx < 0:
                continue
            params = split_params(block[open_idx + 1: close_idx])
            sig = "%s(%s)" % (fm.group(2), "".join(label(p) + ":" for p in params))
            found.setdefault(owner, collections.Counter())[sig] += 1
    return found


def curated_links(text):
    """How many times the page curates each symbol, disambiguation suffix removed.

    A link may carry one — ``f(a:)->T`` or ``f(a:)-1a2b3c`` — precisely where two
    symbols share a name and labels, as TrendingService's sync/async
    `allTrending` pair does. Counting rather than de-duplicating is what makes
    the pair need two lines.
    """
    return collections.Counter(
        re.split(r"->|-(?=[0-9a-f]{6,}$)", link)[0]
        for link in re.findall(r"``([^`]+)``", text))


def undercurated(declared_counts, page_text):
    """{signature: (declarations, curation lines)} for anything short of covered.

    The self-test and the real scan both go through here on purpose: a
    comparison exercised only by the real scan could be broken in a way the
    self-test would not notice, and a clean tree produces no counter-example.
    """
    curated = curated_links(page_text)
    return {sig: (n, curated[sig])
            for sig, n in declared_counts.items() if curated[sig] < n}


failed = False

# --- the extractor still works -------------------------------------------
canary = public_methods(SELF_TEST_SWIFT).get("CanaryService", collections.Counter())
# `twin(gamma:)` is planted twice on purpose: two overloads sharing a name and
# labels need two curation lines, and the page supplies only one.
if canary != collections.Counter({"curated(alpha:)": 1, "curated()": 1,
                                  "forgotten(beta:)": 1, "twin(gamma:)": 2}):
    print("error: SELF_TEST did not extract its own planted methods — the parser")
    print("       is broken, so a clean scan proves nothing. got %s" % dict(canary))
    failed = True
elif undercurated(canary, SELF_TEST_PAGE) != {"forgotten(beta:)": (1, 0),
                                              "twin(gamma:)": (2, 1)}:
    print("error: SELF_TEST did not flag its planted gaps — the comparison is")
    print("       broken, so a clean scan proves nothing. got %s"
          % undercurated(canary, SELF_TEST_PAGE))
    failed = True

if not EXTENSIONS.is_dir():
    sys.exit("error: %s is not a directory — run this from the package root." % EXTENSIONS)

declared = {}
for path in sorted(SOURCES.rglob("*.swift")):
    for owner, sigs in public_methods(path.read_text()).items():
        declared.setdefault(owner, collections.Counter()).update(sigs)

# --- the census is closed -------------------------------------------------
pages = {p.stem for p in EXTENSIONS.glob("*.md")}
gone = EXPECTED_PAGES - pages
if gone:
    print("error: %d curated page(s) are missing:" % len(gone))
    for owner in sorted(gone):
        print("  %s.md" % owner)
    print("\n  A page that disappears takes its methods out of this scan with it.")
    print("  Restore it, or remove it from EXPECTED_PAGES deliberately.")
    failed = True

undeclared = EXPECTED_PAGES - set(declared)
if undeclared:
    print("error: %d curated page(s) match no public protocol — renamed?" % len(undeclared))
    for owner in sorted(undeclared):
        print("  %s" % owner)
    failed = True

missing = []
checked = 0
for owner in sorted(EXPECTED_PAGES & pages & set(declared)):
    if not declared[owner]:
        print("error: %s.md is checked but no public methods were found for it — the"
              % owner)
        print("       scan is broken for that protocol.")
        failed = True
    checked += sum(declared[owner].values())
    page_text = (EXTENSIONS / (owner + ".md")).read_text()
    for sig, counts in sorted(undercurated(declared[owner], page_text).items()):
        missing.append((owner, sig, counts))

if missing:
    print("error: %d public method(s) are absent from their DocC Extensions page:"
          % len(missing))
    for owner, sig, (declared_n, curated_n) in missing:
        detail = ("" if declared_n == 1
                  else "   [%d declarations, %d curation line(s) — overloads sharing a"
                       " name and labels each need their own, disambiguated]"
                       % (declared_n, curated_n))
        print("  %s.%s   (add to %s.md)%s" % (owner, sig, owner, detail))
    print("\n  DocC auto-curates an uncurated symbol into a default topic group")
    print("  WITHOUT a diagnostic, so build-docs cannot catch this.")
    failed = True

if failed:
    sys.exit(1)

print("docc curation check: self-test ok, %d public method(s) across %d page(s), "
      "all curated." % (checked, len(EXPECTED_PAGES)))
