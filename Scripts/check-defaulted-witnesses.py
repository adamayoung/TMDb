#!/usr/bin/env python3
"""Guard the protocol-convenience contract, in both directions.

A default argument *value* is not part of a function's signature for witness
matching. So a convenience in a `public extension` whose parameter list matches
a protocol requirement's — after erasing defaults, INCLUDING erasing none —
silently becomes that requirement's default implementation, and a third-party
conformer that omits the requirement compiles, then recurses until the stack
overflows, where a compile error was intended. See knowledge/gotchas.md.

`SITES` is the 2026-08-07 census: every convenience that shared a requirement's
argument labels, mapped to the parameters that carried defaults. Both tuples
were derived mechanically from the tree, never typed by hand. `REWRITTEN` names
the ones already replaced by explicit no-default overloads; a site is fixed by
adding its key there, which is why no one ever retypes the label tuples.

Four invariants, none of which swiftlint or a regex can express — they need
cross-symbol matching between a protocol and its extension, which no single-file
linter sees.

  1. NO public-extension convenience may share a requirement's (owner, name,
     argument labels) unless it is a not-yet-rewritten `SITES` entry — whatever
     its default count. A *zero*-default duplicate is the same hazard and the
     worst kind, since its body can only call itself: MovieService's
     `releaseDates(forMovie:)` sat in the tree for months because an earlier
     version tested the default count for truthiness and so skipped it.

  2. A not-yet-rewritten site must still be present AND still carry exactly the
     defaults recorded for it. This is what keeps the table honest: while a site
     is unfixed the tree can corroborate it, so the tuple a later rewrite relies
     on has been machine-checked every run up to that point.

  3. A rewritten site must expose its FULL power set — all 2**n - 1 proper
     subsets of its defaulted parameters. Without this the guard is
     deletion-side only: once the defaulted convenience is gone, nothing notices
     whether 7 replacements were written or 6, and a missing one is a silent
     SOURCE BREAK for downstream callers that passes lint, build, test and CI.

  4. The census is closed: `len(SITES)` must equal `TOTAL_SITES`. Deleting an
     entry would otherwise disable its guard silently, since a key absent from
     the table is checked by nothing.

`SELF_TEST` keeps the positive paths alive. Once the tree is clean nothing
in-tree exercises the detector or the subset generator, so a green run would
otherwise be indistinguishable from one whose parsing had broken entirely — and
a *count* floor cannot tell those apart either, because requirements and
conveniences both stay non-zero when default detection breaks. Only running the
machinery over known inputs can.
"""

import itertools
import pathlib
import re
import sys

# Every site of the 2026-08-07 census: (protocol, method, all argument labels)
# -> the labels that carry defaults. Machine-derived; do not hand-edit.
SITES = {
    ("AccountService", "favouriteMovies", ("sortedBy", "page", "accountID", "session")):
        ("sortedBy", "page"),
    ("AccountService", "favouriteTVSeries", ("sortedBy", "page", "accountID", "session")):
        ("sortedBy", "page"),
    ("AccountService", "movieWatchlist", ("sortedBy", "page", "accountID", "session")):
        ("sortedBy", "page"),
    ("AccountService", "ratedMovies", ("sortedBy", "page", "accountID", "session")):
        ("sortedBy", "page"),
    ("AccountService", "ratedTVEpisodes", ("sortedBy", "page", "accountID", "session")):
        ("sortedBy", "page"),
    ("AccountService", "ratedTVSeries", ("sortedBy", "page", "accountID", "session")):
        ("sortedBy", "page"),
    ("AccountService", "tvSeriesWatchlist", ("sortedBy", "page", "accountID", "session")):
        ("sortedBy", "page"),
    ("ChangesService", "movieChanges", ("startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("ChangesService", "movieDetails", ("forMovie", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("ChangesService", "personChanges", ("startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("ChangesService", "personDetails", ("forPerson", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("ChangesService", "tvEpisodeDetails", ("forEpisode", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("ChangesService", "tvSeasonDetails", ("forSeason", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("ChangesService", "tvSeriesChanges", ("startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("ChangesService", "tvSeriesDetails", ("forTVSeries", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("DiscoverService", "movies", ("filter", "sortedBy", "page", "language")):
        ("filter", "sortedBy", "page", "language"),
    ("DiscoverService", "tvSeries", ("filter", "sortedBy", "page", "language")):
        ("filter", "sortedBy", "page", "language"),
    ("MovieService", "alternativeTitles", ("forMovie", "country", "language")):
        ("country", "language"),
    ("MovieService", "changes", ("forMovie", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("MovieService", "changes", ("startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("MovieService", "lists", ("forMovie", "page", "language")):
        ("page", "language"),
    ("MovieService", "nowPlaying", ("page", "country", "language")):
        ("page", "country", "language"),
    ("MovieService", "popular", ("page", "country", "language")):
        ("page", "country", "language"),
    ("MovieService", "recommendations", ("forMovie", "page", "language")):
        ("page", "language"),
    ("MovieService", "reviews", ("forMovie", "page", "language")):
        ("page", "language"),
    ("MovieService", "similar", ("toMovie", "page", "language")):
        ("page", "language"),
    ("MovieService", "topRated", ("page", "country", "language")):
        ("page", "country", "language"),
    ("MovieService", "upcoming", ("page", "country", "language")):
        ("page", "country", "language"),
    ("PersonService", "changes", ("forPerson", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("PersonService", "changes", ("startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("PersonService", "popular", ("page", "language")):
        ("page", "language"),
    ("SearchService", "searchAll", ("query", "filter", "page", "language")):
        ("filter", "page", "language"),
    ("SearchService", "searchCollections", ("query", "page", "language")):
        ("page", "language"),
    ("SearchService", "searchMovies", ("query", "filter", "page", "language")):
        ("filter", "page", "language"),
    ("SearchService", "searchPeople", ("query", "filter", "page", "language")):
        ("filter", "page", "language"),
    ("SearchService", "searchTVSeries", ("query", "filter", "page", "language")):
        ("filter", "page", "language"),
    ("TVEpisodeService", "changes", ("forEpisode", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("TVSeasonService", "changes", ("forSeason", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("TVSeriesService", "airingToday", ("page", "timezone", "language")):
        ("page", "timezone", "language"),
    ("TVSeriesService", "changes", ("forTVSeries", "startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("TVSeriesService", "changes", ("startDate", "endDate", "page")):
        ("startDate", "endDate", "page"),
    ("TVSeriesService", "lists", ("forTVSeries", "page", "language")):
        ("page", "language"),
    ("TVSeriesService", "onTheAir", ("page", "timezone", "language")):
        ("page", "timezone", "language"),
    ("TVSeriesService", "popular", ("page", "language")):
        ("page", "language"),
    ("TVSeriesService", "recommendations", ("forTVSeries", "page", "language")):
        ("page", "language"),
    ("TVSeriesService", "reviews", ("forTVSeries", "page", "language")):
        ("page", "language"),
    ("TVSeriesService", "similar", ("toTVSeries", "page", "language")):
        ("page", "language"),
    ("TVSeriesService", "topRated", ("page", "language")):
        ("page", "language"),
    ("TrendingService", "allTrending", ("inTimeWindow", "page", "language")):
        ("inTimeWindow", "page", "language"),
    ("TrendingService", "movies", ("inTimeWindow", "page", "language")):
        ("inTimeWindow", "page", "language"),
    ("TrendingService", "people", ("inTimeWindow", "page", "language")):
        ("inTimeWindow", "page", "language"),
    ("TrendingService", "tvSeries", ("inTimeWindow", "page", "language")):
        ("inTimeWindow", "page", "language"),
    ("WatchProviderService", "movieWatchProviders", ("filter", "language")):
        ("filter", "language"),
    ("WatchProviderService", "tvSeriesWatchProviders", ("filter", "language")):
        ("filter", "language"),
}

TOTAL_SITES = 54

# Sites already replaced by explicit no-default power-set overloads. Fix a site
# by adding its key here — the label tuples are never retyped.
REWRITTEN = frozenset({
    ("TrendingService", "allTrending", ("inTimeWindow", "page", "language")),
    ("TrendingService", "movies", ("inTimeWindow", "page", "language")),
    ("TrendingService", "people", ("inTimeWindow", "page", "language")),
    ("TrendingService", "tvSeries", ("inTimeWindow", "page", "language")),
    ("WatchProviderService", "movieWatchProviders", ("filter", "language")),
    ("WatchProviderService", "tvSeriesWatchProviders", ("filter", "language")),
})

# A requirement plus two conveniences that witness it: one hidden behind
# defaults, one an exact zero-default duplicate. Invariant 1 must flag both.
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


def has_default(param):
    """True when the parameter carries a default — any value, not just `nil`.

    TrendingService's `inTimeWindow` is a NON-optional
    `TrendingTimeWindowFilterType = .day`, so testing for `= nil` would miss it.
    """
    depth = 0
    for ch in param:
        if ch in "(<[":
            depth += 1
        elif ch in ")>]":
            depth -= 1
        elif ch == "=" and depth == 0:
            return True
    return False


def line_of(text, offset):
    return text.count("\n", 0, offset) + 1


def scan(text, path="<memory>"):
    """(requirements, conveniences) keyed by (owner, name, labels).

    A convenience entry carries the labels that actually carry defaults, so the
    recorded table can be checked against the tree rather than trusted.
    """
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
                conveniences.append((
                    key, path, line_of(text, m.end() + offset),
                    tuple(label(p) for p in params if has_default(p)),
                ))
    return requirements, conveniences


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


def fail(*lines):
    global failed
    failed = True
    for line in lines:
        print(line)


# --- invariant 4: the census is closed ------------------------------------
if len(SITES) != TOTAL_SITES:
    fail("error: SITES holds %d entries, expected %d." % (len(SITES), TOTAL_SITES),
         "       A key absent from SITES is guarded by nothing — restore it, or",
         "       change TOTAL_SITES deliberately and say why in the commit.")

unknown = REWRITTEN - set(SITES)
if unknown:
    fail("error: REWRITTEN names %d site(s) absent from SITES:" % len(unknown),
         *["  " + render(*k) for k in sorted(unknown)])

# The table must be well-formed, or invariant 3 silently checks fewer overloads.
for key, defaulted in sorted(SITES.items()):
    owner, name, labels = key
    if not defaulted:
        fail("error: %s records no defaulted parameters — its power set would be"
             % render(owner, name, labels),
             "       empty, so invariant 3 would check nothing for it.")
    if len(set(defaulted)) != len(defaulted):
        fail("error: %s repeats a defaulted label." % render(owner, name, labels))
    stray = set(defaulted) - set(labels)
    if stray:
        fail("error: %s records defaulted label(s) %s not in its parameter list."
             % (render(owner, name, labels), sorted(stray)))

# --- invariant 0: the machinery itself still works ------------------------
canary_reqs, canary_convs = scan(SELF_TEST)
canary_hits = {c[0] for c in canary_convs if c[0] in canary_reqs}
if canary_hits != {("CanaryService", "canary", ("alpha", "beta")),
                   ("CanaryService", "exact", ("gamma",))}:
    fail("error: SELF_TEST did not detect its own planted witnesses — the parser",
         "       is broken, so a clean scan of Sources proves nothing.",
         "       got %s" % sorted(canary_hits))

canary_defaults = {c[0]: c[3] for c in canary_convs}
if canary_defaults.get(("CanaryService", "canary", ("alpha", "beta"))) != ("alpha", "beta"):
    fail("error: SELF_TEST default detection is broken — invariant 2 would then",
         "       'verify' every recorded tuple against an empty one.")

if (sorted(subsets_of(("a", "b", "c"), ("a", "b", "c")))
        != sorted([(), ("a",), ("b",), ("c",), ("a", "b"), ("a", "c"), ("b", "c")])
        or sorted(subsets_of(("a", "b", "c"), ("b", "c")))
        != sorted([("a",), ("a", "b"), ("a", "c")])):
    fail("error: subsets_of is broken — invariant 3 would demand the wrong set,",
         "       which is the one thing standing between the power-set rewrite",
         "       and a silent source break.")

if not SOURCES.is_dir():
    sys.exit("error: %s is not a directory — run this from the package root." % SOURCES)

requirements, conveniences = {}, []
for path in sorted(SOURCES.rglob("*.swift")):
    reqs, convs = scan(path.read_text(), str(path))
    for key, loc in reqs.items():
        requirements.setdefault(key, loc)
    conveniences.extend(convs)

by_key = {}
for key, path, line, defaulted in conveniences:
    by_key.setdefault(key, []).append((path, line, defaulted))

pending = {k: v for k, v in SITES.items() if k not in REWRITTEN}

# --- invariant 1: no convenience may witness a requirement ----------------
hazards = [c for c in conveniences if c[0] in requirements]
unexpected = [c for c in hazards if c[0] not in pending]
if unexpected:
    fail("error: %d public-extension convenience(s) share a protocol requirement's"
         % len(unexpected),
         "       argument labels, and so become its witness:")
    for key, path, line, defaulted in sorted(unexpected, key=lambda c: (c[1], c[2])):
        note = "   [no defaults — a pure self-recursing duplicate]" if not defaulted else ""
        fail("  %s:%d  %s%s" % (path, line, render(*key), note))
    fail("",
         "  Fix: give the convenience a distinct signature by dropping parameters",
         "       instead of defaulting them — `func f() { f(x: nil) }`, never",
         "       `func f(x: T? = nil) { f(x: x) }`. Where several parameters are",
         "       droppable, add one overload per proper subset and add the site to",
         "       REWRITTEN. A duplicate with no defaults at all is redundant:",
         "       delete it — the requirement already has that signature.",
         "       See knowledge/gotchas.md.")

# --- invariant 2: pending sites are present, with the recorded defaults ---
for key, defaulted in sorted(pending.items()):
    found = by_key.get(key)
    if not found:
        fail("",
             "error: %s is recorded as not yet rewritten, but no such convenience"
             % render(*key),
             "       exists. If you rewrote it, add its key to REWRITTEN.")
        continue
    actual = found[0][2]
    if actual != defaulted:
        fail("",
             "error: %s carries defaults %s, but SITES records %s."
             % (render(*key), list(actual), list(defaulted)),
             "       The recorded tuple drives the power set demanded after the",
             "       rewrite, so it must match the tree while the tree can prove it.")

# --- invariant 3: rewritten sites keep their whole power set --------------
verified = 0
missing = []
for key in sorted(REWRITTEN):
    owner, name, labels = key
    if key in by_key:
        fail("",
             "error: %s is marked REWRITTEN but a convenience with the requirement's"
             % render(*key),
             "       own label list still exists — that is the witness itself.")
    for wanted in subsets_of(labels, SITES[key]):
        if (owner, name, wanted) in by_key:
            verified += 1
        else:
            missing.append((owner, name, wanted, labels))

if missing:
    fail("",
         "error: %d power-set overload(s) are missing — dropping one is a SOURCE"
         % len(missing),
         "       BREAK for callers using that argument combination:")
    for owner, name, wanted, labels in missing:
        fail("  %s   (from %s)" % (render(owner, name, wanted), render(owner, name, labels)))
    fail("",
         "  Add the overload, forwarding the requirement's full label list and",
         "  passing each omitted parameter its own original default.")

if failed:
    sys.exit(1)

print("defaulted-witness check: self-test ok, 0 witnesses, %d overload(s) verified "
      "across %d rewritten site(s), %d site(s) pending."
      % (verified, len(REWRITTEN), len(pending)))
