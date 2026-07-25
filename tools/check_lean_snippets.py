#!/usr/bin/env python3
"""Check every Lean snippet file as a standalone Lean source."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from lean_snippet_support import ROOT, run_lean_file, snippet_files


def check_file(lean_path: Path, lean: str, lake: str) -> bool:
    completed = run_lean_file(lean_path, lean, lake)

    if completed.returncode == 0:
        print(f"ok: {lean_path.relative_to(ROOT)}")
        if completed.stdout:
            sys.stdout.write(completed.stdout)
        if completed.stderr:
            sys.stderr.write(completed.stderr)
        return True

    print(f"failed: {lean_path.relative_to(ROOT)}", file=sys.stderr)
    sys.stderr.write(completed.stdout)
    sys.stderr.write(completed.stderr)
    return False


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", help="Optional lean/<chapter> directories to check.")
    parser.add_argument("--lean", default=str(Path.home() / ".elan" / "bin" / "lean"))
    parser.add_argument("--lake", default=str(Path.home() / ".elan" / "bin" / "lake"))
    args = parser.parse_args()

    failed = False
    for lean_path in snippet_files(args.paths):
        if not lean_path.exists():
            print(f"{lean_path}: file does not exist", file=sys.stderr)
            failed = True
            continue
        failed = not check_file(lean_path, args.lean, args.lake) or failed
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
