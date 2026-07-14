#!/usr/bin/env python3
"""Check the book-wide chapter contract and index wiring."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / "main.tex"

SECTION_RE = re.compile(r"^\\section\{(.+)}$", re.MULTILINE)
CHAPTER_INPUT_RE = re.compile(r"\\input\{(chapters/[^}]+)}")
PART_INPUT_RE = re.compile(r"\\input\{(parts/[^}]+)}")
CHAPTER_REFERENCE_RE = re.compile(r"第([0-9]+)章")
FORWARD_NAVIGATION_RE = re.compile(
    r"次章|次の章|次節|次の節|後続章|後続の第|次に進む"
)
CHAPTER_SCOPE_RE = re.compile(
    r"(?:本章|この章)では[^。\n]*(?:扱わない|扱いません|証明しない|"
    r"証明していません|踏み込みません|網羅しません)"
)
PART_NAVIGATION_RE = re.compile(r"次の部|後続|へ進む|橋渡し|次に読む")
FORBIDDEN_SECTIONS = {
    "次章への接続",
    "本章では扱わないこと",
    "本章ではここまで",
    "本章で証明したことと、しなかったこと",
    "この定理が保証していないこと",
    "本書の範囲外にする理由",
    "次に進むための地図",
    "発展への道",
    "発展読書への橋渡し",
}


def check_chapter(path: Path, errors: list[str]) -> None:
    text = path.read_text(encoding="utf-8")
    rel = path.relative_to(ROOT)
    sections = SECTION_RE.findall(text)

    abstract_count = text.count(r"\begin{chapterabstract}")
    goals_count = text.count(r"\begin{learninggoals}")
    if abstract_count != 1:
        errors.append(f"{rel}: chapterabstract must appear once (found {abstract_count})")
    if goals_count != 1:
        errors.append(f"{rel}: learninggoals must appear once (found {goals_count})")

    abstract_pos = text.find(r"\begin{chapterabstract}")
    goals_pos = text.find(r"\begin{learninggoals}")
    first_section_pos = text.find(r"\section{")
    if not (0 <= abstract_pos < goals_pos < first_section_pos):
        errors.append(f"{rel}: expected abstract -> goals -> sections")

    is_appendix = path.name.startswith("app")
    expected_first = "使い方" if is_appendix else "問題設定"
    expected_last = "本付録のまとめ" if is_appendix else "本章のまとめ"
    if not sections or sections[0] != expected_first:
        actual = sections[0] if sections else "<none>"
        errors.append(f"{rel}: first section must be {expected_first!r} (found {actual!r})")
    if not sections or sections[-1] != expected_last:
        actual = sections[-1] if sections else "<none>"
        errors.append(f"{rel}: last section must be {expected_last!r} (found {actual!r})")
    if sections.count(expected_last) != 1:
        errors.append(f"{rel}: summary section must appear exactly once")

    for section in sections:
        if section in FORBIDDEN_SECTIONS:
            errors.append(f"{rel}: navigation/scope section is not allowed: {section!r}")

    match = FORWARD_NAVIGATION_RE.search(text)
    if match:
        line = text.count("\n", 0, match.start()) + 1
        errors.append(
            f"{rel}:{line}: forward chapter/section navigation is not allowed: "
            f"{match.group(0)!r}"
        )

    match = CHAPTER_SCOPE_RE.search(text)
    if match:
        line = text.count("\n", 0, match.start()) + 1
        errors.append(
            f"{rel}:{line}: chapter non-scope prose is not allowed: "
            f"{match.group(0)!r}"
        )

    chapter_number_match = re.match(r"ch([0-9]+)_", path.name)
    if chapter_number_match and chapter_number_match.group(1) != "00":
        chapter_number = int(chapter_number_match.group(1))
        for reference in CHAPTER_REFERENCE_RE.finditer(text):
            referenced_number = int(reference.group(1))
            if referenced_number > chapter_number:
                line = text.count("\n", 0, reference.start()) + 1
                errors.append(
                    f"{rel}:{line}: forward chapter reference is not allowed: "
                    f"{reference.group(0)!r}"
                )

    if r"\BookIndex{" not in text:
        errors.append(f"{rel}: at least one BookIndex entry is required")


def check_part(path: Path, errors: list[str]) -> None:
    text = path.read_text(encoding="utf-8")
    rel = path.relative_to(ROOT)

    if r"\section*{この部で扱わないこと}" in text:
        errors.append(f"{rel}: non-scope section is not allowed")
    if r"\section*{次の部への接続}" in text:
        errors.append(f"{rel}: next-part section is not allowed")

    match = PART_NAVIGATION_RE.search(text)
    if match:
        line = text.count("\n", 0, match.start()) + 1
        errors.append(
            f"{rel}:{line}: forward part navigation is not allowed: "
            f"{match.group(0)!r}"
        )


def main() -> int:
    errors: list[str] = []
    main_text = MAIN.read_text(encoding="utf-8")
    chapter_paths = [ROOT / f"{name}.tex" for name in CHAPTER_INPUT_RE.findall(main_text)]
    part_paths = [ROOT / f"{name}.tex" for name in PART_INPUT_RE.findall(main_text)]
    template = ROOT / "chapters/chXX_template.tex"

    if not chapter_paths:
        errors.append("main.tex: no chapter inputs found")
    for path in [*chapter_paths, template]:
        if not path.exists():
            errors.append(f"{path.relative_to(ROOT)}: referenced source is missing")
            continue
        check_chapter(path, errors)
    for path in part_paths:
        if not path.exists():
            errors.append(f"{path.relative_to(ROOT)}: referenced source is missing")
            continue
        check_part(path, errors)

    preamble_text = (ROOT / "preamble.tex").read_text(encoding="utf-8")
    macros_text = (ROOT / "macros.tex").read_text(encoding="utf-8")
    if r"\usepackage{makeidx}" not in preamble_text or r"\makeindex" not in preamble_text:
        errors.append("preamble.tex: makeidx and makeindex are required")
    if r"\newcommand{\BookIndex}" not in macros_text:
        errors.append("macros.tex: BookIndex helper is required")
    if r"\printindex" not in main_text:
        errors.append("main.tex: printindex is required in the back matter")
    latexmkrc_text = (ROOT / ".latexmkrc").read_text(encoding="utf-8")
    if "upmendex" not in latexmkrc_text:
        errors.append(".latexmkrc: upmendex must generate the Japanese index")

    if errors:
        print("Book structure check failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        f"Book structure check passed: {len(chapter_paths)} included chapters/appendices, "
        f"{len(part_paths)} part prefaces, plus the chapter template."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
