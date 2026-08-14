#!/usr/bin/env python3
"""Fail the lint when README's install snippet points at the wrong version.

`.package(url: ..., from: "X.Y.Z")` is the first thing anyone copies, and SemVer
reads `from:` as `>=X.Y.Z, <X+1.0.0`. So a stale major there does not merely look
untidy — it silently caps every new consumer below the release they came for.
PR #406 caught exactly this by hand while preparing 19.0.0: the snippet still
said `18.0.0`, which no reader could have resolved to 19.0.0.

Nothing else catches it. `make build-docs` compiles the DocC catalog, not README;
`markdownlint` checks shape, not truth; and no test resolves the package the way
a reader would. It is invisible by construction until someone files a bug about
the wrong version, which is the *False green* family this repo keeps hitting.

**Why CHANGELOG.md and not `git tag`.** CI checks out without tags by default, so
a tag-based check would pass vacuously on the very runs it exists to guard.
`CHANGELOG.md` is checked in, is already this repo's authoritative record of what
shipped (`/cut-release` treats it the same way), and cannot be shallow-fetched
away.

**The rule.** README's `from:` must equal EITHER:

  * the newest DATED section  — the last release, the normal steady state; or
  * the newest UNDATED section — the release being prepared.

The second arm is what keeps the release window from deadlocking. `/cut-release`
bumps README and dates the CHANGELOG in one housekeeping PR that merges minutes
before the tag; during that PR the tag does not exist yet, and a stricter check
would block the very commit it is asking for.

Anything else fails: a README left behind after a release (newest dated moved on),
or bumped to a version nobody has begun (matches neither).
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
CHANGELOG = ROOT / "CHANGELOG.md"

# `## [20.0.0]` or `## [19.0.0] - 2026-07-29`. Anchored at `^## [` so the link
# definitions at the foot of the file (`[19.0.0]: https://...`) cannot match.
SECTION = re.compile(r"^## \[(\d+\.\d+\.\d+)\](\s*-\s*\d{4}-\d{2}-\d{2})?\s*$")

# The dependency line in the install snippet. Anchored on the repo URL so an
# unrelated `.package(...)` in a sample cannot satisfy or break the check.
PACKAGE = re.compile(
    r'\.package\(\s*url:\s*"https://github\.com/adamayoung/TMDb\.git"\s*,\s*(?P<req>[^)]*)\)'
)
FROM_VERSION = re.compile(r'from:\s*"(\d+\.\d+\.\d+)"')


def fail(message: str) -> None:
    print(f"check-readme-version: {message}", file=sys.stderr)
    sys.exit(1)


def changelog_versions() -> tuple[str | None, str | None]:
    """Return (newest_dated, newest_undated) in file order — newest is first."""
    newest_dated: str | None = None
    newest_undated: str | None = None

    for line in CHANGELOG.read_text(encoding="utf-8").splitlines():
        match = SECTION.match(line)
        if not match:
            continue
        version, date = match.group(1), match.group(2)
        if date:
            if newest_dated is None:
                newest_dated = version
        elif newest_undated is None:
            newest_undated = version

    return newest_dated, newest_undated


def readme_version() -> str:
    text = README.read_text(encoding="utf-8")
    packages = PACKAGE.findall(text)

    if not packages:
        fail(
            "no `.package(url: \"https://github.com/adamayoung/TMDb.git\", ...)` found in README.md. "
            "If the install snippet moved or changed shape, update this check with it — "
            "a check that silently matches nothing is worse than no check."
        )

    versions = set()
    for requirement in packages:
        found = FROM_VERSION.search(requirement)
        if not found:
            fail(
                f"install snippet uses an unsupported requirement: `{requirement.strip()}`. "
                "This check only understands `from: \"X.Y.Z\"`. Teach it the new form rather "
                "than deleting the check."
            )
        versions.add(found.group(1))

    if len(versions) > 1:
        fail(f"README.md declares conflicting versions: {', '.join(sorted(versions))}.")

    return versions.pop()


def main() -> None:
    for path in (README, CHANGELOG):
        if not path.exists():
            fail(f"{path.name} not found at {path}.")

    declared = readme_version()
    newest_dated, newest_undated = changelog_versions()

    if newest_dated is None and newest_undated is None:
        fail("CHANGELOG.md has no `## [X.Y.Z]` sections — cannot verify the README version.")

    accepted = [v for v in (newest_dated, newest_undated) if v is not None]
    if declared in accepted:
        return

    detail = []
    if newest_dated:
        detail.append(f"last released: {newest_dated}")
    if newest_undated:
        detail.append(f"in preparation: {newest_undated}")

    fail(
        f'README.md install snippet says from: "{declared}", which matches neither '
        f"({'; '.join(detail)}).\n"
        "  SemVer reads `from:` as `>=X.Y.Z, <X+1.0.0`, so a stale major here caps every\n"
        "  new consumer below the release they came for. Update the snippet in README.md,\n"
        "  or add the CHANGELOG section for the version you meant.\n"
        "  /cut-release does this as pre-tag housekeeping — see its Phase 3."
    )


if __name__ == "__main__":
    main()
