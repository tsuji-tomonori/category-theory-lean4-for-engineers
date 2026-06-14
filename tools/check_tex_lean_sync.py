#!/usr/bin/env python3
"""Check that Lean snippets embedded in chapter TeX match lean/*.lean files.

The comparison ignores Lean line comments so book-only annotations such as
``#eval foo -- expected`` do not drift from the compilable source file.
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHAPTERS_DIR = ROOT / "chapters"
LEAN_DIR = ROOT / "lean"
LEAN_LANGS = {"lean", "lean4"}


BEGIN_RE = re.compile(r"\\begin\{minted\}(?:\[[^\]]*\])?\{([^}]+)\}")
END_RE = re.compile(r"\\end\{minted\}")
INPUT_RE = re.compile(r"\\(?:input|include)\{([^}]+)\}")
NAMESPACE_RE = re.compile(r"^\s*namespace\s+\S+\s*$")
SECTION_RE = re.compile(r"^\s*section(?:\s+\S+)?\s*$")
UNIVERSE_RE = re.compile(r"^\s*universe\s+.+$")
END_NAMESPACE_RE = re.compile(r"^\s*end\s+\S+\s*$")
IMPORT_RE = re.compile(r"^\s*import\s+.+$")
OPEN_RE = re.compile(r"^\s*open(?:\s+scoped)?\s+.+$")


@dataclass(frozen=True)
class Snippet:
    tex_path: Path
    start_line: int
    language: str
    code: str


def strip_lean_line_comment(line: str) -> str:
    in_string = False
    escaped = False

    for index, char in enumerate(line):
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
            continue
        if char == "-" and index + 1 < len(line) and line[index + 1] == "-":
            return line[:index]

    return line


def strip_lean_comments(code: str) -> str:
    result: list[str] = []
    index = 0
    in_line_comment = False
    block_depth = 0
    in_string = False
    escaped = False

    while index < len(code):
        char = code[index]
        next_char = code[index + 1] if index + 1 < len(code) else ""

        if in_line_comment:
            if char == "\n":
                result.append(char)
                in_line_comment = False
            index += 1
            continue

        if block_depth:
            if char == "/" and next_char == "-":
                block_depth += 1
                index += 2
                continue
            if char == "-" and next_char == "/":
                block_depth -= 1
                index += 2
                continue
            if char == "\n":
                result.append(char)
            index += 1
            continue

        if in_string:
            result.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue

        if char == '"':
            in_string = True
            result.append(char)
            index += 1
            continue
        if char == "-" and next_char == "-":
            in_line_comment = True
            index += 2
            continue
        if char == "/" and next_char == "-":
            block_depth = 1
            index += 2
            continue

        result.append(char)
        index += 1

    return "".join(result)


def normalize_code(code: str) -> str:
    lines = [line.rstrip() for line in code.replace("\r\n", "\n").split("\n")]
    while lines and not lines[0]:
        lines.pop(0)
    while lines and not lines[-1]:
        lines.pop()
    return "\n".join(lines)


def normalize_lean_code(code: str) -> str:
    lines = [line.rstrip() for line in strip_lean_comments(code.replace("\r\n", "\n")).split("\n")]
    lines = [
        line
        for line in lines
        if line
        and not NAMESPACE_RE.match(line)
        and not SECTION_RE.match(line)
        and not UNIVERSE_RE.match(line)
        and not END_NAMESPACE_RE.match(line)
        and not IMPORT_RE.match(line)
        and not OPEN_RE.match(line)
    ]
    return "\n".join(lines)


def compact_line(line: str) -> str:
    return " ".join(line.split())


def lines_match(snippet_line: str, lean_line: str) -> bool:
    left = compact_line(snippet_line)
    right = compact_line(lean_line)
    return left == right or left in right or right in left


def extract_minted_snippets(tex_path: Path) -> list[Snippet]:
    snippets: list[Snippet] = []
    language: str | None = None
    start_line = 0
    body: list[str] = []

    for line_no, line in enumerate(tex_path.read_text(encoding="utf-8").splitlines(), start=1):
        if language is None:
            match = BEGIN_RE.search(line)
            if match is None:
                continue
            language = match.group(1).strip().lower()
            start_line = line_no
            body = []
            continue

        if END_RE.search(line):
            if language in LEAN_LANGS:
                snippets.append(
                    Snippet(
                        tex_path=tex_path,
                        start_line=start_line,
                        language=language,
                        code=normalize_lean_code("\n".join(body)),
                    )
                )
            language = None
            start_line = 0
            body = []
            continue

        body.append(line)

    if language is not None:
        rel_path = tex_path.relative_to(ROOT)
        raise ValueError(f"{rel_path}:{start_line}: minted block is not closed")

    return snippets


def matching_lean_paths(tex_path: Path) -> list[Path]:
    snippet_dir = LEAN_DIR / tex_path.stem
    if snippet_dir.is_dir():
        return sorted(snippet_dir.glob("code*.lean"))
    return [LEAN_DIR / f"{tex_path.stem}.lean"]


def check_tex_file(tex_path: Path) -> list[str]:
    snippets = extract_minted_snippets(tex_path)
    if not snippets:
        return []

    rel_tex = tex_path.relative_to(ROOT)
    lean_paths = matching_lean_paths(tex_path)
    missing_paths = [path for path in lean_paths if not path.exists()]
    if missing_paths:
        missing = ", ".join(str(path.relative_to(ROOT)) for path in missing_paths)
        return [f"{rel_tex}: matching Lean file is missing: {missing}"]

    snippet_dir = LEAN_DIR / tex_path.stem
    if snippet_dir.is_dir():
        errors: list[str] = []
        if len(lean_paths) != len(snippets):
            errors.append(
                f"{rel_tex}: Lean snippet file count mismatch: "
                f"{len(snippets)} TeX snippet(s), {len(lean_paths)} file(s) in {snippet_dir.relative_to(ROOT)}"
            )
        for snippet, lean_path in zip(snippets, lean_paths, strict=False):
            lean_lines = normalize_lean_code(lean_path.read_text(encoding="utf-8")).splitlines()
            snippet_lines = normalize_lean_code(snippet.code).splitlines()
            search_from = 0
            missing_line = ""
            for snippet_line in snippet_lines:
                found_at = next(
                    (
                        index
                        for index in range(search_from, len(lean_lines))
                        if lines_match(snippet_line, lean_lines[index])
                    ),
                    None,
                )
                if found_at is None:
                    missing_line = snippet_line
                    break
                if compact_line(snippet_line) == compact_line(lean_lines[found_at]):
                    search_from = found_at + 1
                else:
                    search_from = found_at
            if missing_line:
                errors.append(
                    f"{rel_tex}:{snippet.start_line}: Lean snippet does not match "
                    f"{lean_path.relative_to(ROOT)}; missing line: {missing_line!r}"
                )
        return errors

    lean_path = lean_paths[0]
    lean_lines = normalize_lean_code(lean_path.read_text(encoding="utf-8")).splitlines()
    errors: list[str] = []

    for snippet in snippets:
        snippet_lines = normalize_lean_code(snippet.code).splitlines()
        if not snippet_lines:
            continue
        search_from = 0
        missing_line = ""
        for snippet_line in snippet_lines:
            found_at = next(
                (
                    index
                    for index in range(search_from, len(lean_lines))
                    if lines_match(snippet_line, lean_lines[index])
                ),
                None,
            )
            if found_at is None:
                missing_line = snippet_line
                break
            if compact_line(snippet_line) == compact_line(lean_lines[found_at]):
                search_from = found_at + 1
            else:
                search_from = found_at
        if missing_line:
            errors.append(
                f"{rel_tex}:{snippet.start_line}: Lean snippet does not match "
                f"{lean_path.relative_to(ROOT)}; missing line: {missing_line!r}"
            )

    return errors


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

    for match in INPUT_RE.finditer(path.read_text(encoding="utf-8")):
        raw_input = match.group(1)
        input_path = (ROOT / raw_input).with_suffix(".tex")
        collected.extend(collect_tex_inputs(input_path, seen))

    return collected


def chapter_tex_files(paths: list[str]) -> list[Path]:
    if paths:
        return [Path(path).resolve() for path in paths]
    return sorted(set(collect_tex_inputs(ROOT / "main.tex")))


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Verify that Lean code blocks in chapter TeX files match lean/*.lean files."
    )
    parser.add_argument("paths", nargs="*", help="Optional chapter .tex files to check.")
    parser.add_argument(
        "--baseline",
        type=Path,
        default=ROOT / "tools" / "tex_lean_sync_baseline.txt",
        help="Known mismatch baseline file. Baseline entries are ignored.",
    )
    parser.add_argument(
        "--update-baseline",
        action="store_true",
        help="Write the current mismatch list to --baseline.",
    )
    args = parser.parse_args()

    errors: list[str] = []
    checked_tex = 0
    checked_snippets = 0

    for tex_path in chapter_tex_files(args.paths):
        if not tex_path.exists():
            errors.append(f"{tex_path}: file does not exist")
            continue
        snippets = extract_minted_snippets(tex_path)
        checked_snippets += len(snippets)
        if snippets:
            checked_tex += 1
        errors.extend(check_tex_file(tex_path))

    errors = sorted(errors)

    baseline_path = args.baseline.resolve()
    baseline: set[str] = set()
    if baseline_path.exists():
        baseline = set(
            line.strip()
            for line in baseline_path.read_text(encoding="utf-8").splitlines()
            if line.strip() and not line.startswith("#")
        )

    if args.update_baseline:
        baseline_path.parent.mkdir(parents=True, exist_ok=True)
        baseline_path.write_text("\n".join(errors) + ("\n" if errors else ""), encoding="utf-8")
        print(f"Updated baseline: {baseline_path.relative_to(ROOT)} ({len(errors)} entries)")
        return 0

    new_errors = [error for error in errors if error not in baseline]

    if new_errors:
        print("TeX/Lean sync check failed:", file=sys.stderr)
        for error in new_errors:
            print(f"- {error}", file=sys.stderr)
        if baseline:
            print(f"{len(errors) - len(new_errors)} known mismatch(es) ignored by baseline.", file=sys.stderr)
        return 1

    ignored = len(errors) - len(new_errors)
    suffix = f"; {ignored} known mismatch(es) ignored by baseline" if ignored else ""
    print(f"TeX/Lean sync check passed: {checked_snippets} snippets in {checked_tex} chapter files{suffix}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
