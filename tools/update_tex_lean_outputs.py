#!/usr/bin/env python3
"""Annotate Lean commands in chapter TeX with their actual Lean output."""

from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import tempfile
from collections import defaultdict, deque
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHAPTERS_DIR = ROOT / "chapters"
LEAN_DIR = ROOT / "lean"
LEAN_LANGS = {"lean", "lean4"}
COMMAND_RE = re.compile(r"^(\s*)#(eval|check|reduce)\b")
BEGIN_RE = re.compile(r"\\begin\{minted\}(?:\[[^\]]*\])?\{([^}]+)\}")
END_RE = re.compile(r"\\end\{minted\}")
INPUT_RE = re.compile(r"\\(?:input|include)\{([^}]+)\}")
OUTPUT_COMMENT_RE = re.compile(r"^\s*--\s*=>\s*")


@dataclass(frozen=True)
class Command:
    text: str
    start: int
    end: int
    indent: str


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


def normalize_command(lines: list[str]) -> str:
    cleaned = [strip_lean_line_comment(line).rstrip() for line in lines]
    while cleaned and not cleaned[0].strip():
        cleaned.pop(0)
    while cleaned and not cleaned[-1].strip():
        cleaned.pop()
    return "\n".join(cleaned)


def balance_delta(line: str) -> int:
    code = strip_lean_line_comment(line)
    opens = code.count("(") + code.count("[") + code.count("{")
    closes = code.count(")") + code.count("]") + code.count("}")
    return opens - closes


def is_command_start(line: str) -> bool:
    return COMMAND_RE.match(line) is not None


def extract_commands_from_lines(lines: list[str]) -> list[Command]:
    commands: list[Command] = []
    index = 0
    while index < len(lines):
        match = COMMAND_RE.match(lines[index])
        if match is None:
            index += 1
            continue

        start = index
        indent = match.group(1)
        body = [lines[index]]
        balance = balance_delta(lines[index])
        index += 1

        while index < len(lines):
            line = lines[index]
            if OUTPUT_COMMENT_RE.match(line):
                break
            if balance <= 0 and (not line.startswith((" ", "\t")) or not line.strip()):
                break
            body.append(line)
            balance += balance_delta(line)
            index += 1

        commands.append(Command(normalize_command(body), start, index - 1, indent))
    return commands


def instrument_lean_source(lines: list[str], commands: list[Command]) -> str:
    marker_by_start = {command.start: index for index, command in enumerate(commands)}
    result: list[str] = []
    for index, line in enumerate(lines):
        if index in marker_by_start:
            result.append(f'#eval "__LEAN_OUTPUT_MARKER_{marker_by_start[index]}__"')
        result.append(line)
    return "\n".join(result) + "\n"


def parse_marked_output(lines: list[str], command_count: int) -> list[list[str]]:
    marker_re = re.compile(r'^"__LEAN_OUTPUT_MARKER_(\d+)__"$')
    chunks: list[list[str]] = [[] for _ in range(command_count)]
    current: int | None = None

    for line in lines:
        if not line.strip():
            continue
        if ": warning:" in line or line.startswith("Note: This linter can be disabled"):
            continue
        marker = marker_re.match(line)
        if marker is not None:
            current = int(marker.group(1))
            continue
        if current is None:
            continue
        chunks[current].append(line)

    missing = [index for index, chunk in enumerate(chunks) if not chunk]
    if missing:
        raise RuntimeError(f"missing Lean output for command marker(s): {missing}")
    return chunks


def lean_command_outputs(lean_path: Path, lean: str, lake: str) -> dict[str, deque[list[str]]]:
    source_lines = lean_path.read_text(encoding="utf-8").splitlines()
    commands = extract_commands_from_lines(source_lines)
    if not commands:
        return {}

    instrumented = instrument_lean_source(source_lines, commands)
    with tempfile.NamedTemporaryFile("w", encoding="utf-8", suffix=".lean", delete=False) as temp:
        temp.write(instrumented)
        temp_path = Path(temp.name)

    if lean_path.name == "ch34_mathlib_category_theory.lean":
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

    if completed.returncode != 0:
        sys.stderr.write(completed.stdout)
        sys.stderr.write(completed.stderr)
        raise RuntimeError(f"Lean command failed for {lean_path.relative_to(ROOT)}")

    marked_lines = [
        line
        for line in completed.stdout.splitlines()
        if line.strip()
        and ": warning:" not in line
        and not line.startswith("Note: This linter can be disabled")
    ]
    chunks = parse_marked_output(marked_lines, len(commands))

    outputs: dict[str, deque[list[str]]] = defaultdict(deque)
    for command, output in zip(commands, chunks, strict=True):
        outputs[command.text].append(output)
    return outputs


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
        collected.extend(collect_tex_inputs((ROOT / match.group(1)).with_suffix(".tex"), seen))
    return collected


def matching_lean_path(tex_path: Path) -> Path:
    return LEAN_DIR / f"{tex_path.stem}.lean"


def format_output(output: list[str], indent: str) -> list[str]:
    if len(output) == 1:
        return [f"{indent}-- => {output[0]}"]
    return [f"{indent}-- =>", *[f"{indent}-- {line}" for line in output]]


def remove_existing_output_block(lines: list[str], index: int) -> int:
    if index >= len(lines) or not OUTPUT_COMMENT_RE.match(lines[index]):
        return 0

    removed = 1
    scan = index + 1
    while scan < len(lines) and re.match(r"^\s*--\s+", lines[scan]):
        removed += 1
        scan += 1
    del lines[index : index + removed]
    return removed


def annotate_minted_block(block: list[str], outputs: dict[str, deque[list[str]]]) -> tuple[list[str], int]:
    commands = extract_commands_from_lines(block)
    if not commands:
        return block, 0

    lines = list(block)
    offset = 0
    changed = 0
    for command in commands:
        if command.text not in outputs or not outputs[command.text]:
            continue

        output = outputs[command.text].popleft()
        start = command.start + offset
        end = command.end + offset
        output_lines = format_output(output, command.indent)

        if start == end and len(output) == 1:
            code = strip_lean_line_comment(lines[start]).rstrip()
            lines[start] = f"{code}  -- => {output[0]}"
        else:
            insert_at = end + 1
            removed = remove_existing_output_block(lines, insert_at)
            lines[insert_at:insert_at] = output_lines
            offset += len(output_lines) - removed
        changed += 1

    return lines, changed


def annotate_tex_file(tex_path: Path, outputs: dict[str, deque[str]]) -> int:
    original = tex_path.read_text(encoding="utf-8").splitlines()
    result: list[str] = []
    language: str | None = None
    block: list[str] = []
    changed = 0

    for line in original:
        if language is None:
            result.append(line)
            match = BEGIN_RE.search(line)
            if match is not None:
                language = match.group(1).strip().lower()
                block = []
            continue

        if END_RE.search(line):
            if language in LEAN_LANGS:
                annotated, count = annotate_minted_block(block, outputs)
                result.extend(annotated)
                changed += count
            else:
                result.extend(block)
            result.append(line)
            language = None
            block = []
            continue

        block.append(line)

    if language is not None:
        raise RuntimeError(f"{tex_path.relative_to(ROOT)}: minted block is not closed")

    new_text = "\n".join(result) + "\n"
    if new_text != tex_path.read_text(encoding="utf-8"):
        tex_path.write_text(new_text, encoding="utf-8")
    return changed


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", help="Optional chapter .tex files to update.")
    parser.add_argument("--lean", default=str(Path.home() / ".elan" / "bin" / "lean"))
    parser.add_argument("--lake", default=str(Path.home() / ".elan" / "bin" / "lake"))
    args = parser.parse_args()

    tex_paths = [Path(path).resolve() for path in args.paths] if args.paths else sorted(set(collect_tex_inputs(ROOT / "main.tex")))
    output_cache: dict[Path, dict[str, deque[list[str]]]] = {}
    total = 0

    for tex_path in tex_paths:
        lean_path = matching_lean_path(tex_path)
        if not lean_path.exists():
            continue
        if lean_path not in output_cache:
            output_cache[lean_path] = lean_command_outputs(lean_path, args.lean, args.lake)
        total += annotate_tex_file(tex_path, {key: deque(value) for key, value in output_cache[lean_path].items()})

    print(f"Annotated {total} Lean command output(s) in {len(tex_paths)} TeX file(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
