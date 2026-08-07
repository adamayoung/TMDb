#!/usr/bin/env python3
"""Fail the lint when a public-extension convenience can witness its requirement.

A default argument *value* is not part of a function's signature for witness
matching. So a convenience in a `public extension` whose parameter list matches
a protocol requirement's after erasing defaults silently becomes that
requirement's default implementation — and a third-party conformer that omits
the requirement compiles, then recurses until the stack overflows, where a
compile error was intended. See knowledge/gotchas.md.

Two invariants, both enforced here because neither swiftlint nor a regex can
express them: they need cross-symbol matching between a protocol and its
extension, which no single-file linter sees.

  1. NO site may have exactly one defaulted parameter. Those are fixable for
     the cost of a single dropped-parameter overload, so there is never a
     reason to leave one.
  2. The multi-default sites must be EXACTLY the set in DEFERRED below. Those
     need the power set of overloads to stay call-site compatible, so they are
     deliberately deferred to the next major (knowledge/next-major.md).

Invariant 2 is a set comparison rather than a count for two reasons. A count
lets a fix and a regression cancel out to the same number and pass green. And
a count of zero — which is what a scan that silently found nothing produces —
would satisfy "at most 54"; a checker whose green is indistinguishable from
"it never ran" is not a checker.

When you fix a deferred site, delete its line from DEFERRED. At empty, delete
this script and its `make lint` / ci.yml steps.
"""

import pathlib
import re
import sys

# (protocol, method, argument labels) for every convenience deliberately left
# with 2+ defaulted parameters. Frozen 2026-08-07 at the 20.0.0 sweep.
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
    ("WatchProviderService", "movieWatchProviders", ("filter", "language")),
    ("WatchProviderService", "tvSeriesWatchProviders", ("filter", "language")),
})

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


def site(hazard):
    (owner, name, labels), path, line, _ = hazard
    return "%s:%d  %s.%s(%s)" % (path, line, owner, name, "".join(l + ":" for l in labels))


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

hazards = [h for h in conveniences if h[3] and h[0] in requirements]
single = [h for h in hazards if h[3] == 1]
multi = [h for h in hazards if h[3] > 1]
found = {h[0] for h in multi}

failed = False

if single:
    failed = True
    print("error: %d public-extension convenience(s) differ from a protocol requirement "
          "ONLY by a default argument, and so become its witness:" % len(single))
    for hazard in sorted(single, key=lambda h: str(h[1])):
        print("  " + site(hazard))
    print("\n  Fix: drop the defaulted parameter instead of defaulting it —")
    print("       `func f() { f(x: nil) }`, not `func f(x: T? = nil) { f(x: x) }`.")
    print("       See knowledge/gotchas.md.")

added = found - DEFERRED
if added:
    failed = True
    print("\nerror: %d new multi-default witness site(s):" % len(added))
    for hazard in sorted((h for h in multi if h[0] in added), key=lambda h: str(h[1])):
        print("  " + site(hazard))
    print("\n  Give the convenience a distinct signature (drop the defaulted parameters),")
    print("  or add it to DEFERRED here and to knowledge/next-major.md.")

gone = DEFERRED - found
if gone:
    failed = True
    print("\nerror: %d site(s) in DEFERRED were not found:" % len(gone))
    for owner, name, labels in sorted(gone):
        print("  %s.%s(%s)" % (owner, name, "".join(l + ":" for l in labels)))
    print("\n  Either they were fixed — delete them from DEFERRED and update")
    print("  knowledge/next-major.md — or this scan did not see what it should have.")

if failed:
    sys.exit(1)

print("defaulted-witness check: 0 single-default sites, %d deferred sites as expected."
      % len(found))
