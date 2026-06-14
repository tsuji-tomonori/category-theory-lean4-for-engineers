#!/usr/bin/env python3
"""Check chapter Lean snippet files by running each chapter as one Lean source."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEAN_DIR = ROOT / "lean"
MATHLIB_CHAPTER = "ch34_mathlib_category_theory"
SKIP_MARKER = "check-lean-snippets: skip"


def snippet_dirs(paths: list[str]) -> list[Path]:
    if paths:
        return [Path(path).resolve() for path in paths]
    return sorted(path for path in LEAN_DIR.iterdir() if path.is_dir())


def read_chapter_source(chapter_dir: Path) -> str:
    files = [
        path
        for path in sorted(chapter_dir.glob("code*.lean"))
        if SKIP_MARKER not in path.read_text(encoding="utf-8")
    ]
    if not files:
        raise RuntimeError(f"{chapter_dir.relative_to(ROOT)}: no code*.lean files found")
    return "\n\n".join(path.read_text(encoding="utf-8") for path in files)


def check_chapter(chapter_dir: Path, lean: str, lake: str) -> bool:
    source = read_chapter_source(chapter_dir)
    with tempfile.NamedTemporaryFile("w", encoding="utf-8", suffix=".lean", delete=False) as temp:
        temp.write(source)
        temp_path = Path(temp.name)

    if chapter_dir.name == MATHLIB_CHAPTER:
        argv = [lake, "env", "lean", str(temp_path)]
    else:
        argv = [lean, str(temp_path)]

    try:
        completed = subprocess.run(
            argv,
            cwd=ROOT,
            check=False,
            text=True,
            capture_output=True,
            env={**os.environ, "PATH": f"{Path(lean).parent}:{os.environ.get('PATH', '')}"},
        )
    finally:
        temp_path.unlink(missing_ok=True)

    if completed.returncode == 0:
        print(f"ok: {chapter_dir.relative_to(ROOT)}")
        return True

    print(f"failed: {chapter_dir.relative_to(ROOT)}", file=sys.stderr)
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
    for chapter_dir in snippet_dirs(args.paths):
        if not chapter_dir.exists():
            print(f"{chapter_dir}: directory does not exist", file=sys.stderr)
            failed = True
            continue
        failed = not check_chapter(chapter_dir, args.lean, args.lake) or failed
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
