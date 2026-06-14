#!/usr/bin/env python3
"""Check every Lean snippet file as a standalone Lean source."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEAN_DIR = ROOT / "lean"
MATHLIB_CHAPTER = "ch34_mathlib_category_theory"


def snippet_files(paths: list[str]) -> list[Path]:
    if paths:
        selected: list[Path] = []
        for raw_path in paths:
            path = Path(raw_path).resolve()
            if path.is_dir():
                selected.extend(sorted(path.glob("code*.lean")))
            else:
                selected.append(path)
        return selected
    return sorted(LEAN_DIR.glob("*/code*.lean"))


def check_file(lean_path: Path, lean: str, lake: str) -> bool:
    if lean_path.parent.name == MATHLIB_CHAPTER:
        argv = [lake, "env", "lean", str(lean_path)]
    else:
        argv = [lean, str(lean_path)]

    completed = subprocess.run(
        argv,
        cwd=ROOT,
        check=False,
        text=True,
        capture_output=True,
        env={**os.environ, "PATH": f"{Path(lean).parent}:{os.environ.get('PATH', '')}"},
    )

    if completed.returncode == 0:
        print(f"ok: {lean_path.relative_to(ROOT)}")
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
