#!/usr/bin/env python3
"""Shared discovery and execution helpers for standalone Lean snippets."""

from __future__ import annotations

import os
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
LEAN_DIR = ROOT / "lean"
MATHLIB_CHAPTER = "ch40_mathlib_category_theory"


def snippet_files(paths: list[str]) -> list[Path]:
    """Return selected ``code*.lean`` files in deterministic order."""
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


def lean_argv(lean_path: Path, lean: str, lake: str, *, json_output: bool = False) -> list[str]:
    """Build the Lean command for a snippet, including Mathlib's Lake environment."""
    if lean_path.parent.name == MATHLIB_CHAPTER:
        argv = [lake, "env", "lean", str(lean_path)]
    else:
        argv = [lean, str(lean_path)]
    if json_output:
        argv.append("--json")
    return argv


def run_lean_file(
    lean_path: Path,
    lean: str,
    lake: str,
    *,
    json_output: bool = False,
) -> subprocess.CompletedProcess[str]:
    """Run one Lean snippet from the repository root and capture its output."""
    return subprocess.run(
        lean_argv(lean_path, lean, lake, json_output=json_output),
        cwd=ROOT,
        check=False,
        text=True,
        capture_output=True,
        env={**os.environ, "PATH": f"{Path(lean).parent}:{os.environ.get('PATH', '')}"},
    )
