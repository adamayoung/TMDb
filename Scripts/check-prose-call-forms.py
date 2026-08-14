#!/usr/bin/env python3
"""Fail the lint when a code sample calls a method that does not exist.

Nothing compiles a code sample. `make build-docs` builds the DocC *catalog*, not
the Swift inside a ```swift fence, and `markdownlint` does not read it either —
so a sample that drifts out of date is invisible to CI by construction, and only
a reader or a reviewer ever finds it. It is the first code anyone copies.

This has now bitten three times: PR #359 (a cross-module DocC break), PR #452 (a
stale `search("…")` corrected in `README.md` while the identical call survived in
two `.docc` articles), and PR #459, whose sweep found `README.md` documenting
`tmdbClient.search.multi(query:)` — a method that has never existed. The
improvement log named this exact trigger: an enforceable check earns its place on
the third recurrence.

**Scope: calls made through a service on `TMDbClient`.** That is where the drift
happens and where a wrong sample misleads, and anchoring on the client's own
service properties is what keeps the check quiet — a sample also calls
`voteAverage.formatted()`, `task.cancel()` and `urlRequest.setValue(_:forHTTPHeaderField:)`,
none of which are ours to verify. So the receiver must be a service property of
`TMDbClient` (`movies`, `trending`, `v4Lists`, `naturalLanguageSearch`, …),
whether reached as `client.movies.details(…)` or through a binding
(`let movies = client.movies` … `movies.details(…)`).

Resolution is by name **and argument labels**, since the labels are what go
stale, and a call is allowed to omit any parameter that carries a default.
"""

import itertools
import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else ".")
SOURCES = ROOT / "Sources"

# A sample calling a *known* service under a name that is not a client property
# would silently go unchecked, so the mapping is discovered rather than listed —
# but the count is pinned, because discovering nothing must not read as success.
MIN_SERVICES = 26
MIN_CALL_FORMS = 70

SELF_TEST_CLIENT = '''
public final class TMDbClient {
    public let movies: any MovieService
}
'''

SELF_TEST_SERVICE = '''
public protocol MovieService: Sendable {
    func details(forMovie movieID: Int, language: String?) async throws -> Movie
}

public extension MovieService {
    func details(forMovie movieID: Int) async throws -> Movie {
        try await details(forMovie: movieID, language: nil)
    }

    func popular(page: Int? = nil) async throws -> MoviePageableList {
        try await popular(page: page)
    }
}
'''

# Plants one of each: a call through the client, a short form reached by
# omitting a defaulted parameter, a call through a binding, a stale label set,
# a call on a type that is not ours, and a local shadowing a service name.
SELF_TEST_PROSE = '''
```swift
let movie = try await client.movies.details(forMovie: 550)
let popular = try await client.movies.popular()
let movies = client.movies
let credits = try await movies.details(forMovie: 550)
let stale = try await client.movies.details(movie: 550)
let notOurs = voteAverage.formatted()
let trending = try await client.trending.movies()
if let first = trending.first(where: { $0.id == 550 }) { print(first) }
```
'''


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


def split_args(inner):
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


def declared_label(param):
    return param.strip().split(":")[0].split()[0]


def services(text):
    """Service property name -> protocol, from client properties and accessors."""
    found = {}
    for m in re.finditer(
        r"(?:public )?(?:let|var) ([a-zA-Z][A-Za-z0-9_]*)\s*:\s*any ([A-Za-z0-9_]+Service)\b",
        text,
    ):
        found[m.group(1)] = m.group(2)
    return found


def methods(text):
    """protocol -> {"name(a:b:)"} for every public method, defaults expanded.

    A call may omit any defaulted parameter, so each declaration contributes
    every call form it permits — otherwise a legitimate short form in a sample
    would be reported as missing.
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
            params = split_args(block[open_idx + 1: close_idx])
            labels = [declared_label(p) for p in params]
            defaulted = [i for i, p in enumerate(params) if "=" in p]
            required = [i for i in range(len(params)) if i not in defaulted]
            for r in range(len(defaulted) + 1):
                for chosen in itertools.combinations(defaulted, r):
                    keep = sorted(required + list(chosen))
                    sig = "%s(%s)" % (fm.group(2),
                                      "".join(labels[i] + ":" for i in keep))
                    found.setdefault(owner, set()).add(sig)
    return found


def call_forms(text, service_names):
    """(receiver, signature, line) for every service call in a ```swift fence."""
    out = []
    for body, first_line in swift_fences(text):
        out.extend(fence_call_forms(body, first_line, service_names))
    return out


def swift_fences(text):
    """(body, line number of the body's first line) for each ```swift fence."""
    fences, body, start, in_fence = [], [], 0, False
    for n, line in enumerate(text.split("\n"), 1):
        if line.strip().startswith("```"):
            if in_fence:
                fences.append(("\n".join(body), start))
                body, in_fence = [], False
            elif line.strip().startswith("```swift"):
                in_fence, start = True, n + 1
            continue
        if in_fence:
            body.append(line)
    return fences


def fence_call_forms(body, first_line, service_names):
    """Calls in one fence, parsed over the WHOLE fence rather than line by line.

    A sample wraps its longer calls across lines, and a line-by-line scan
    silently skips those — which is the shape most likely to have drifted,
    since it is the call with the most arguments to get wrong.
    """
    out = []
    # A `let movies = client.movies` binding makes later `movies.details(…)`
    # calls ours to check too. A binding to anything *else* does the opposite:
    # `let watchProviders = try await client.movies.watchProviders(forMovie:)`
    # shadows the service of the same name with an array, and its `.first(where:)`
    # is Swift's, not ours.
    bindings, shadowed = {}, set()

    # Bindings and calls are interleaved by position, so a name shadowed part-way
    # down a sample still resolves correctly above that point.
    events = []
    for bm in re.finditer(
        r"^[ \t]*(?:let|var)\s+([a-zA-Z][A-Za-z0-9_]*)\s*(?::[^=\n]+)?=[ \t]*(.*)$",
        body, re.M,
    ):
        events.append((bm.start(), "bind", bm))
    for cm in re.finditer(r"\b([a-zA-Z][A-Za-z0-9_]*)\.([a-zA-Z][A-Za-z0-9_]*)\s*\(", body):
        events.append((cm.start(), "call", cm))

    for _, kind, m in sorted(events, key=lambda e: e[0]):
        if kind == "bind":
            bound, rhs = m.group(1), m.group(2).strip()
            alias = re.fullmatch(r"[a-zA-Z][A-Za-z0-9_]*\.([a-zA-Z][A-Za-z0-9_]*)", rhs)
            if alias and alias.group(1) in service_names:
                bindings[bound] = alias.group(1)
                shadowed.discard(bound)
            else:
                shadowed.add(bound)
                bindings.pop(bound, None)
            continue

        receiver, name = m.group(1), m.group(2)
        if receiver in shadowed:
            continue
        service = receiver if receiver in service_names else bindings.get(receiver)
        if service is None:
            continue
        open_idx = body.index("(", m.end() - 1)
        close_idx = closing_paren(body, open_idx)
        if close_idx < 0:
            continue                          # an unbalanced sample; nothing to check
        args = split_args(body[open_idx + 1: close_idx])
        labels = []
        for a in args:
            if ":" not in a.split("(")[0]:
                labels = None                 # positional or trailing closure
                break
            labels.append(a.split(":")[0].strip())
        if labels is None:
            continue
        line = first_line + body.count("\n", 0, m.start())
        out.append((service, "%s(%s)" % (name, "".join(l + ":" for l in labels)), line))
    return out


failed = False

# --- the extractor still works -------------------------------------------
canary_services = services(SELF_TEST_CLIENT)
canary_methods = methods(SELF_TEST_SERVICE)
canary_calls = call_forms(SELF_TEST_PROSE, set(canary_services))
canary_bad = [(s, sig) for s, sig, _ in canary_calls
              if sig not in canary_methods.get(canary_services[s], set())]

if canary_services != {"movies": "MovieService"}:
    print("error: SELF_TEST found services %s — the client parser is broken."
          % canary_services)
    failed = True
elif "popular()" not in canary_methods.get("MovieService", set()):
    print("error: SELF_TEST did not expand a defaulted parameter into its short")
    print("       call form, so every legitimate short form would be reported.")
    failed = True
elif [sig for _, sig in canary_bad] != ["details(movie:)"]:
    print("error: SELF_TEST flagged %s, expected exactly the planted stale call"
          % [sig for _, sig in canary_bad])
    print("       `details(movie:)`. Either drift is not detected, or a valid")
    print("       call — or a non-service call like `voteAverage.formatted()` —")
    print("       is being reported.")
    failed = True

if not SOURCES.is_dir():
    sys.exit("error: %s is not a directory — run this from the package root." % SOURCES)

service_map, method_map = {}, {}
for path in sorted(SOURCES.rglob("*.swift")):
    text = path.read_text()
    service_map.update(services(text))
    for owner, sigs in methods(text).items():
        method_map.setdefault(owner, set()).update(sigs)

if len(service_map) < MIN_SERVICES:
    print("error: found %d client service properties, expected at least %d — the"
          % (len(service_map), MIN_SERVICES))
    print("       scan is broken, so a clean result would mean nothing.")
    failed = True

prose = [ROOT / "README.md"] + sorted(SOURCES.rglob("*.docc/**/*.md"))
unresolved, checked = [], 0
for path in prose:
    if not path.is_file():
        continue
    for service, sig, line in call_forms(path.read_text(), set(service_map)):
        checked += 1
        protocol = service_map[service]
        if sig not in method_map.get(protocol, set()):
            unresolved.append((path, line, service, protocol, sig))

if checked < MIN_CALL_FORMS:
    print("error: matched only %d call form(s) in the prose, expected at least %d"
          % (checked, MIN_CALL_FORMS))
    print("       — the sample extractor is broken, not the samples.")
    failed = True

if unresolved:
    print("error: %d code sample(s) call a method that does not exist:" % len(unresolved))
    for path, line, service, protocol, sig in unresolved:
        rel = path.relative_to(ROOT) if path.is_relative_to(ROOT) else path
        print("  %s:%d  %s.%s   (no such method on %s)" % (rel, line, service, sig, protocol))
    print("\n  Nothing compiles a code sample, so this is the only thing that")
    print("  checks them. Fix the sample — or the method name, if the sample is")
    print("  right and the API drifted.")
    failed = True

if failed:
    sys.exit(1)

print("prose call-form check: self-test ok, %d call form(s) across %d service(s), "
      "all resolve." % (checked, len(service_map)))
