#!/usr/bin/env python3
"""Reject unclassified sorry/admit/axiom declarations in Lean sources."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ALLOWLIST = ROOT / "tools" / "lean_assumption_allowlist.txt"
TOKEN_RE = re.compile(r"\b(sorry|admit|axiom)\b")


def strip_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)
    return "\n".join(line.split("--", 1)[0] for line in text.splitlines())


def load_allowlist() -> dict[str, set[str]]:
    allowed: dict[str, set[str]] = {}
    for line_no, raw in enumerate(ALLOWLIST.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split("|", 2)
        if len(parts) != 3 or not parts[2].strip():
            raise ValueError(f"{ALLOWLIST.relative_to(ROOT)}:{line_no}: reason is required")
        path, kinds, _reason = parts
        allowed[path] = {kind.strip() for kind in kinds.split(",")}
    return allowed


def main() -> int:
    allowed = load_allowlist()
    errors: list[str] = []
    classified = 0
    for path in sorted((ROOT / "lean").glob("**/*.lean")):
        rel = str(path.relative_to(ROOT))
        text = strip_comments(path.read_text(encoding="utf-8"))
        for line_no, line in enumerate(text.splitlines(), 1):
            for match in TOKEN_RE.finditer(line):
                kind = match.group(1)
                if kind in allowed.get(rel, set()):
                    classified += 1
                else:
                    errors.append(f"{rel}:{line_no}: unclassified {kind}")
    missing = sorted(set(allowed) - {str(p.relative_to(ROOT)) for p in (ROOT / "lean").glob("**/*.lean")})
    errors.extend(f"allowlist path does not exist: {path}" for path in missing)
    if errors:
        print("Lean assumption check failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print(f"Lean assumption check passed: {classified} classified template occurrence(s), no unclassified assumptions")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
