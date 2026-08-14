#!/usr/bin/env python3
"""Guard the protocol-convenience contract, in both directions.

A default argument *value* is not part of a function's signature for witness
matching. So a convenience in a `public extension` whose parameter list matches
a protocol requirement's — after erasing defaults, INCLUDING erasing none —
silently becomes that requirement's default implementation, and a third-party
conformer that omits the requirement compiles, then recurses until the stack
overflows, where a compile error was intended. See knowledge/gotchas.md.

Three invariants, none of which swiftlint or a regex can express: they need
cross-symbol matching between a protocol and its extension, which no
single-file linter sees.

  1. NO public-extension convenience may share a requirement's (owner, name,
     argument labels) — whatever its default count. A *zero*-default duplicate
     is the same hazard and the worst kind, since its body can only call
     itself: `MovieService.releaseDates(forMovie:)` lived in the tree for
     months because an earlier version of this script tested the default count
     for truthiness and so skipped it.
  2. Every site fixed by the power-set rewrite must still expose its FULL power
     set. `POWER_SETS` records, per rewritten site, which parameters used to
     carry defaults; the check regenerates the 2**n - 1 proper subsets and
     fails if any overload is missing. Without this the guard is deletion-side
     only: after the defaulted convenience is deleted, nothing notices whether
     7 replacements were written or 6, and a missing one is a silent SOURCE
     BREAK for downstream callers that passes lint, build, test and CI green.
  3. Sites not yet rewritten must match `DEFERRED` exactly — a set, not a
     count, so a fix and a regression cannot cancel out. It is empty now; a new
     entry means someone deferred a site and owes knowledge/next-major.md a
     note.

`SELF_TEST` keeps invariant 1's positive path alive. With no defaulted witness
left in `Sources`, nothing in-tree exercises the detector, so a green run would
look identical to a run whose parsing had broken entirely — the failure mode the
docstring of the previous version warned about, reintroduced by its own success.
A count floor cannot catch that (requirements and conveniences both stay
non-zero when default detection breaks); only running the detector over a known
hazard can.
"""

import itertools
import pathlib
import re
import sys

# Rewritten sites: (protocol, method, all argument labels) -> the labels that
# used to carry a default. Each must still expose every proper subset of those.
POWER_SETS = {
    ("WatchProviderService", "movieWatchProviders", ("filter", "language")):
        ("filter", "language"),
    ("WatchProviderService", "tvSeriesWatchProviders", ("filter", "language")):
        ("filter", "language"),
}

# Sites still carrying multiple defaults, deliberately not yet rewritten.
DEFERRED = frozenset({
    ("AccountService", "favouriteMovies", ("sortedBy", "page", "accountID", "session")),
    ("AccountService", "favouriteTVSeries", ("sortedBy", "page", "accountID", "session")),
    ("AccountService", "movieWatchlist", ("sortedBy", "page", "accountID", "session")),
    ("AccountService", "ratedMovies", ("sortedBy", "page", "accountID", "session")),
    ("AccountService", "ratedTVEpisodes", ("sortedBy", "page", "accountID", "session")),
    ("AccountService", "ratedTVSeries", ("sortedBy", "page", "accountID", "session")),
    ("AccountService", "tvSeriesWatchlist", ("sortedBy", "page", "accountID", "session")),
    ("ChangesService", "movieChanges", ("startDate", "endDate", "page")),
    ("ChangesService", "movieDetails", ("forMovie", "startDate", "endDate", "page")),
    ("ChangesService", "personChanges", ("startDate", "endDate", "page")),
    ("ChangesService", "personDetails", ("forPerson", "startDate", "endDate", "page")),
    ("ChangesService", "tvEpisodeDetails", ("forEpisode", "startDate", "endDate", "page")),
    ("ChangesService", "tvSeasonDetails", ("forSeason", "startDate", "endDate", "page")),
    ("ChangesService", "tvSeriesChanges", ("startDate", "endDate", "page")),
    ("ChangesService", "tvSeriesDetails", ("forTVSeries", "startDate", "endDate", "page")),
    ("DiscoverService", "movies", ("filter", "sortedBy", "page", "language")),
    ("DiscoverService", "tvSeries", ("filter", "sortedBy", "page", "language")),
    ("MovieService", "alternativeTitles", ("forMovie", "country", "language")),
    ("MovieService", "changes", ("forMovie", "startDate", "endDate", "page")),
    ("MovieService", "changes", ("startDate", "endDate", "page")),
    ("MovieService", "lists", ("forMovie", "page", "language")),
    ("MovieService", "nowPlaying", ("page", "country", "language")),
    ("MovieService", "popular", ("page", "country", "language")),
    ("MovieService", "recommendations", ("forMovie", "page", "language")),
    ("MovieService", "reviews", ("forMovie", "page", "language")),
    ("MovieService", "similar", ("toMovie", "page", "language")),
    ("MovieService", "topRated", ("page", "country", "language")),
    ("MovieService", "upcoming", ("page", "country", "language")),
    ("PersonService", "changes", ("forPerson", "startDate", "endDate", "page")),
    ("PersonService", "changes", ("startDate", "endDate", "page")),
    ("PersonService", "popular", ("page", "language")),
    ("SearchService", "searchAll", ("query", "filter", "page", "language")),
    ("SearchService", "searchCollections", ("query", "page", "language")),
    ("SearchService", "searchMovies", ("query", "filter", "page", "language")),
    ("SearchService", "searchPeople", ("query", "filter", "page", "language")),
    ("SearchService", "searchTVSeries", ("query", "filter", "page", "language")),
    ("TVEpisodeService", "changes", ("forEpisode", "startDate", "endDate", "page")),
    ("TVSeasonService", "changes", ("forSeason", "startDate", "endDate", "page")),
    ("TVSeriesService", "airingToday", ("page", "timezone", "language")),
    ("TVSeriesService", "changes", ("forTVSeries", "startDate", "endDate", "page")),
    ("TVSeriesService", "changes", ("startDate", "endDate", "page")),
    ("TVSeriesService", "lists", ("forTVSeries", "page", "language")),
    ("TVSeriesService", "onTheAir", ("page", "timezone", "language")),
    ("TVSeriesService", "popular", ("page", "language")),
    ("TVSeriesService", "recommendations", ("forTVSeries", "page", "language")),
    ("TVSeriesService", "reviews", ("forTVSeries", "page", "language")),
    ("TVSeriesService", "similar", ("toTVSeries", "page", "language")),
    ("TVSeriesService", "topRated", ("page", "language")),
    ("TrendingService", "allTrending", ("inTimeWindow", "page", "language")),
    ("TrendingService", "movies", ("inTimeWindow", "page", "language")),
    ("TrendingService", "people", ("inTimeWindow", "page", "language")),
    ("TrendingService", "tvSeries", ("inTimeWindow", "page", "language")),
})

# A protocol requirement plus a convenience that witnesses it. Invariant 1 must
# flag this, or the detector is not working.
SELF_TEST = '''
public protocol CanaryService {
    func canary(alpha: String?, beta: Int?) async throws -> Int
    func exact(gamma: String) async throws -> Int
}

public extension CanaryService {
    func canary(alpha: String? = nil, beta: Int? = nil) async throws -> Int {
        try await canary(alpha: alpha, beta: beta)
    }

    func exact(gamma: String) async throws -> Int {
        try await exact(gamma: gamma)
    }
}
'''

SOURCES = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "Sources")


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


def scan(text, path="<memory>"):
    """Return (requirements, conveniences) keyed by (owner, name, labels)."""
    requirements, conveniences = {}, []
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
    return requirements, conveniences


def site(hazard):
    (owner, name, labels), path, line, _ = hazard
    return "%s:%d  %s.%s(%s)" % (path, line, owner, name, "".join(l + ":" for l in labels))


def render(owner, name, labels):
    return "%s.%s(%s)" % (owner, name, "".join(l + ":" for l in labels))


def subsets_of(all_labels, defaulted):
    """Every PROPER subset of `defaulted`, as a label tuple in original order."""
    kept = [l for l in all_labels if l not in defaulted]
    out = []
    for r in range(len(defaulted)):
        for chosen in itertools.combinations(defaulted, r):
            keep = set(kept) | set(chosen)
            out.append(tuple(l for l in all_labels if l in keep))
    return out


failed = False

# --- invariant 0: the detector itself still works -------------------------
canary_reqs, canary_convs = scan(SELF_TEST)
canary_hits = {c[0] for c in canary_convs if c[0] in canary_reqs}
expected = {
    ("CanaryService", "canary", ("alpha", "beta")),
    ("CanaryService", "exact", ("gamma",)),
}
if canary_hits != expected:
    failed = True
    print("error: SELF_TEST did not detect its own planted witnesses — the")
    print("       parser is broken, so a clean scan of Sources proves nothing.")
    print("       expected %s\n       got      %s" % (sorted(expected), sorted(canary_hits)))

if not SOURCES.is_dir():
    sys.exit("error: %s is not a directory — run this from the package root." % SOURCES)

requirements, conveniences = {}, []
for path in sorted(SOURCES.rglob("*.swift")):
    reqs, convs = scan(path.read_text(), str(path))
    for key, loc in reqs.items():
        requirements.setdefault(key, loc)
    conveniences.extend(convs)

by_key = {}
for key, path, line, ndef in conveniences:
    by_key.setdefault(key, []).append((path, line, ndef))

# --- invariant 1: no convenience may witness a requirement ----------------
# Any default count, including zero: the hazard is the matching parameter list,
# not the defaults that hid it.
hazards = [h for h in conveniences if h[0] in requirements]
unexpected = [h for h in hazards if h[0] not in DEFERRED]

if unexpected:
    failed = True
    print("error: %d public-extension convenience(s) share a protocol requirement's"
          % len(unexpected))
    print("       argument labels, and so become its witness:")
    for hazard in sorted(unexpected, key=lambda h: str(h[1])):
        print("  " + site(hazard) + ("   [no defaults — a pure self-recursing duplicate]"
                                     if hazard[3] == 0 else ""))
    print("\n  Fix: give the convenience a distinct signature by dropping parameters")
    print("       instead of defaulting them — `func f() { f(x: nil) }`, never")
    print("       `func f(x: T? = nil) { f(x: x) }`. Where several parameters are")
    print("       droppable, add one overload per proper subset and record the site")
    print("       in POWER_SETS. A duplicate with no defaults at all is redundant:")
    print("       delete it, the requirement already has that signature.")
    print("       See knowledge/gotchas.md.")

# --- invariant 2: rewritten sites keep their whole power set --------------
missing = []
for (owner, name, labels), defaulted in sorted(POWER_SETS.items()):
    for wanted in subsets_of(labels, defaulted):
        if (owner, name, wanted) not in by_key:
            missing.append((owner, name, wanted, labels))

if missing:
    failed = True
    print("\nerror: %d power-set overload(s) are missing — dropping one is a SOURCE"
          % len(missing))
    print("       BREAK for callers using that argument combination:")
    for owner, name, wanted, labels in missing:
        print("  %s   (from %s)" % (render(owner, name, wanted), render(owner, name, labels)))
    print("\n  Add the overload, forwarding the requirement's full label list and")
    print("  passing each omitted parameter its own original default.")

# --- invariant 3: the deferred set is exactly what is left ----------------
found_deferred = {h[0] for h in hazards}
added = found_deferred - DEFERRED
gone = DEFERRED - found_deferred

if gone:
    failed = True
    print("\nerror: %d site(s) in DEFERRED were not found:" % len(gone))
    for owner, name, labels in sorted(gone):
        print("  " + render(owner, name, labels))
    print("\n  Either they were rewritten — move them to POWER_SETS with the labels")
    print("  that used to be defaulted, and update knowledge/next-major.md — or")
    print("  this scan did not see what it should have.")

if failed:
    sys.exit(1)

print("defaulted-witness check: self-test ok, 0 witnesses, "
      "%d rewritten site(s) with complete power sets, %d deferred."
      % (len(POWER_SETS), len(DEFERRED)))
