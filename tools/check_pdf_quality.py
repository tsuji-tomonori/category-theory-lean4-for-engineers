#!/usr/bin/env python3
"""Fail release builds on known blocking LaTeX/PDF quality warnings."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LOG = ROOT / "main.log"
OVERFULL_RE = re.compile(r"Overfull \\hbox \(([-0-9.]+)pt too wide\)")


def main() -> int:
    if not LOG.exists():
        print("main.log is missing; run make first", file=sys.stderr)
        return 1
    text = LOG.read_text(encoding="utf-8", errors="replace")
    errors: list[str] = []
    blockers = {
        "missing character": r"^Missing character:",
        "undefined reference": r"Reference `[^']+' .* undefined",
        "undefined citation": r"Citation `[^']+' .* undefined",
        "multiply defined label": r"multiply defined",
        "empty bibliography": r"Empty `thebibliography' environment",
    }
    for label, pattern in blockers.items():
        count = len(re.findall(pattern, text, flags=re.MULTILINE | re.IGNORECASE))
        if count:
            errors.append(f"{label}: {count}")
    too_wide = [float(value) for value in OVERFULL_RE.findall(text) if float(value) > 2.0]
    if too_wide:
        errors.append(f"overfull hbox > 2pt: {len(too_wide)} (max {max(too_wide):.2f}pt)")
    if errors:
        print("PDF quality check failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print("PDF quality check passed: no blocking warnings")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
