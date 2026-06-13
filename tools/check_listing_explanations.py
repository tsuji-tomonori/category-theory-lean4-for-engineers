#!/usr/bin/env python3
"""Check that code listings are followed by explanatory prose.

This is a lightweight editorial check.  It does not judge the quality of the
explanation; it only flags a listing when the next meaningful line looks like a
new structural element instead of prose or an explanatory box.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHAPTERS_DIR = ROOT / "chapters"

INPUT_RE = re.compile(r"\\(?:input|include)\{([^}]+)\}")
END_LISTING_RE = re.compile(r"\\end\{listing\}")
SECTION_RE = re.compile(r"\\(?:chapter|part|section|subsection|subsubsection)\b")
STRUCTURAL_RE = re.compile(
    r"\\(?:begin\{listing\}|FigurePlaceholder|begin\{center\}|begin\{tabular\}|end\{document\})"
)
EXPLANATION_BOX_RE = re.compile(
    r"\\begin\{(?:leanbox|intuitionbox|definitionbox|softwarebox|warningbox|summarybox|syntaxbox)\}"
)


def collect_tex_inputs(path: Path, seen: set[Path] | None = None) -> list[Path]:
    if seen is None:
        seen = set()
    path = path.resolve()
    if path in seen or not path.exists():
        return []
    seen.add(path)

    collected: list[Path] = []
    if path.parent == CHAPTERS_DIR and path.suffix == ".tex":
        collected.append(path)

    text = path.read_text(encoding="utf-8")
    for match in INPUT_RE.finditer(text):
        input_path = (ROOT / match.group(1)).with_suffix(".tex")
        collected.extend(collect_tex_inputs(input_path, seen))

    return collected


def chapter_tex_files(paths: list[str]) -> list[Path]:
    if paths:
        return [Path(path).resolve() for path in paths]
    return sorted(set(collect_tex_inputs(ROOT / "main.tex")))


def is_comment_or_blank(line: str) -> bool:
    stripped = line.strip()
    return not stripped or stripped.startswith("%")


def is_explanation_start(line: str) -> bool:
    stripped = line.strip()
    if EXPLANATION_BOX_RE.match(stripped):
        return True
    if stripped.startswith("\\") and not stripped.startswith("\\texttt"):
        return False
    return True


def check_tex_file(tex_path: Path) -> list[str]:
    lines = tex_path.read_text(encoding="utf-8").splitlines()
    errors: list[str] = []

    for index, line in enumerate(lines):
        if not END_LISTING_RE.search(line):
            continue

        next_index = index + 1
        while next_index < len(lines) and is_comment_or_blank(lines[next_index]):
            next_index += 1

        rel_path = tex_path.relative_to(ROOT)
        listing_line = index + 1
        if next_index >= len(lines):
            errors.append(f"{rel_path}:{listing_line}: listing is not followed by explanatory prose")
            continue

        next_line = lines[next_index].strip()
        if is_explanation_start(next_line):
            continue
        if SECTION_RE.search(next_line) or STRUCTURAL_RE.search(next_line):
            errors.append(
                f"{rel_path}:{listing_line}: listing is followed by structure, not explanation: {next_line}"
            )
            continue
        errors.append(f"{rel_path}:{listing_line}: listing explanation is missing or unclear: {next_line}")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify that TeX listings are followed by explanatory prose.")
    parser.add_argument("paths", nargs="*", help="Optional chapter .tex files to check.")
    args = parser.parse_args()

    errors: list[str] = []
    checked_files = 0
    for tex_path in chapter_tex_files(args.paths):
        if not tex_path.exists():
            errors.append(f"{tex_path}: file does not exist")
            continue
        file_errors = check_tex_file(tex_path)
        checked_files += 1
        errors.extend(file_errors)

    if errors:
        print("Listing explanation check failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print(f"Listing explanation check passed: {checked_files} chapter files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
