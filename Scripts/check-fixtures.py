#!/usr/bin/env python3
"""Fail the lint when a JSON test fixture is invalid, dishonest, or unreferenced.

Three defects, none of which any existing gate can see:

  1. INVALID JSON. Foundation's parser accepts trailing commas, so a fixture can
     be strictly-invalid JSON and still decode green in the test suite forever.
     `media-pageable-list.json` carried one for years. A Swift-based validator
     cannot catch this — it would use the same tolerant parser — which is why
     this check is Python: an INDEPENDENT strict parser is the whole point.

  2. camelCase KEYS. `JSONDecoder.theMovieDatabase` sets `.convertFromSnakeCase`,
     which leaves a key with no underscore unchanged. So a hand-written
     `"originalName"` matches the CodingKey just as well as the `"original_name"`
     TMDb actually sends — the fixture passes while proving nothing about the
     wire format. TMDb is uniformly snake_case, so a camelCase key means a
     fixture someone invented rather than captured.

  3. ORPHANS, BOTH WAYS. A fixture no test reads implies coverage that does not
     exist (20 of them had accumulated). And a `fromResource:` naming a file that
     is not on disk fails only at *test* run time, so this catches it at lint
     time instead. Checking both directions costs a few lines and is sound here:
     of 195 call sites none builds a name from parts.

Two design rules this script must keep, both learned the hard way:

  * A parse failure must never MASK a key defect in the same file. Check 2 walks
    the parsed structure when parsing succeeds (precise) and falls back to a
    raw-text key scan when it does not. `media-pageable-list.json` had both
    defects at once; a parse-then-walk checker would have reported only one and
    the other would have survived the very PR that added this script.

  * A checker whose green is indistinguishable from "it never ran" is not a
    checker (see Scripts/check-defaulted-witnesses.py, and knowledge/gotchas.md
    "False green"). So an empty scan is a FAILURE, not a pass, and success
    prints the counts it actually looked at.

There is deliberately NO allowlist for check 2. An always-empty allowlist is
untested code and a one-line bypass for the defect being fixed. If TMDb ever
genuinely sends a camelCase key, add one then — and give it the staleness check
`DEFERRED` has, so it cannot rot silently.
"""

import json
import pathlib
import re
import sys

FIXTURE_DIR = pathlib.Path("Tests/TMDbTests/Resources")
SWIFT_DIR = pathlib.Path("Tests")

# A key that starts lower-case and then has a capital: `originalName`, `creditId`.
CAMEL_KEY = re.compile(r"^[a-z0-9]+[A-Z]")

# Raw-text fallback for files that do not parse: a quoted key followed by a colon.
RAW_KEY = re.compile(r'"([A-Za-z0-9_]+)"\s*:')

# Any quoted, fixture-name-shaped string literal in a Swift test.
SWIFT_LITERAL = re.compile(r'"([A-Za-z0-9][A-Za-z0-9._-]*)"')

# A direct `fromResource: "name"` argument. The handful of parameterised call
# sites pass a variable, and their names appear in literal `arguments:` arrays,
# so those are covered by SWIFT_LITERAL above and simply not reverse-checked.
FROM_RESOURCE = re.compile(r'fromResource:\s*"([^"]+)"')


def camel_keys(node, found):
    """Collect camelCase keys from a parsed JSON structure, recursively."""
    if isinstance(node, dict):
        for key, value in node.items():
            if CAMEL_KEY.match(key):
                found.add(key)
            camel_keys(value, found)
    elif isinstance(node, list):
        for item in node:
            camel_keys(item, found)


def main():
    fixtures = sorted(FIXTURE_DIR.rglob("*.json"))
    swift_files = sorted(SWIFT_DIR.rglob("*.swift"))

    failed = False

    # Degenerate-scan guard: zero files means a wrong path or a wrong CWD, and
    # its output would otherwise be indistinguishable from a clean tree.
    if not fixtures:
        print("error: no JSON fixtures found under %s — wrong directory?" % FIXTURE_DIR)
        failed = True
    if not swift_files:
        print("error: no Swift files found under %s — wrong directory?" % SWIFT_DIR)
        failed = True
    if failed:
        sys.exit(1)

    unparseable = []
    camel = {}

    for path in fixtures:
        text = path.read_text(encoding="utf-8")
        try:
            parsed = json.loads(text)
        except ValueError as error:
            unparseable.append((path, error))
            # Do NOT skip the key check — a parse failure must not mask it.
            keys = {m for m in RAW_KEY.findall(text) if CAMEL_KEY.match(m)}
        else:
            keys = set()
            camel_keys(parsed, keys)
        if keys:
            camel[path] = sorted(keys)

    literals = set()
    referenced = set()
    for path in swift_files:
        text = path.read_text(encoding="utf-8")
        literals.update(SWIFT_LITERAL.findall(text))
        referenced.update(FROM_RESOURCE.findall(text))

    # The forward direction fails loudly if `literals` comes back empty (every
    # fixture would read as an orphan), but the reverse direction would not: an
    # empty `referenced` yields an empty `missing` and a silent pass. Rename the
    # `fromResource:` label or the loader helpers and this check would quietly
    # stop measuring anything, which is the one thing this script must not do.
    if not referenced:
        print(
            "error: no `fromResource:` references found under %s — has the fixture "
            "loader been renamed?" % SWIFT_DIR
        )
        sys.exit(1)

    names = {path.stem: path for path in fixtures}
    orphans = sorted(set(names) - literals)
    missing = sorted(referenced - set(names))

    if unparseable:
        failed = True
        print("error: %d fixture(s) are not valid JSON:" % len(unparseable))
        for path, error in unparseable:
            print("  %s — %s" % (path, error))
        print("\n  Foundation's decoder tolerates some of this (trailing commas),")
        print("  so the test suite passes while the file is malformed. Fix the JSON.")

    if camel:
        failed = True
        print("\nerror: %d fixture(s) use camelCase keys where TMDb sends snake_case:" % len(camel))
        for path, keys in sorted(camel.items()):
            print("  %s — %s" % (path, ", ".join(keys)))
        print("\n  `.convertFromSnakeCase` leaves these unchanged, so they match the")
        print("  CodingKey and the test passes without proving anything about the")
        print("  real payload. Re-capture from the live API, or rename the key.")

    if orphans:
        failed = True
        print("\nerror: %d fixture(s) are referenced by no test:" % len(orphans))
        for name in orphans:
            print("  %s" % names[name])
        print("\n  A fixture nothing reads implies coverage that does not exist.")
        print("  Wire it into a decode test, or delete it.")

    if missing:
        failed = True
        print("\nerror: %d fromResource: reference(s) name a fixture that is not on disk:" % len(missing))
        for name in missing:
            print("  %s.json" % name)
        print("\n  This would fail at test run time; it is cheaper to catch here.")

    if failed:
        sys.exit(1)

    print(
        "fixture check: %d fixtures valid, snake_case and referenced "
        "(%d Swift files scanned, %d fromResource: references resolved)."
        % (len(fixtures), len(swift_files), len(referenced))
    )


if __name__ == "__main__":
    main()
