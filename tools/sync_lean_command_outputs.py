#!/usr/bin/env python3
"""Generate Lean command outputs as comments inside the book's code listings.

The compilable ``lean/**/codeNN.lean`` files remain the source of truth. Each
file is executed with Lean's JSON diagnostic output, and informational messages
emitted by commands such as ``#check``, ``#eval``, ``#reduce``, ``#print``, and
``#synth`` are copied into both the source file and the matching TeX ``minted``
block as generated Lean comments.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

from check_tex_lean_sync import (
    BEGIN_RE,
    END_RE,
    LEAN_LANGS,
    chapter_tex_files,
    matching_lean_paths,
    strip_lean_comments,
)
from lean_snippet_support import ROOT, run_lean_file


OUTPUT_MARKER = "-- 出力:"
OUTPUT_CONTINUATION = "--   "
REQUIRED_OUTPUT_COMMANDS = {"check", "eval", "eval!", "reduce", "print", "synth"}
HASH_COMMAND_RE = re.compile(
    r"^(?P<indent>[ \t]*)#(?P<name>[A-Za-z_][A-Za-z0-9_']*[!?]?)(?=\s|$)"
)
GENERATED_START_RE = re.compile(r"^[ \t]*-- 出力:(?:\s.*)?$")
GENERATED_CONTINUATION_RE = re.compile(r"^[ \t]*--(?:   .*|\s*)$")
LEGACY_OUTPUT_RE = re.compile(r"^[ \t]*--[ \t]*=>(?P<value>.*)$")
COMMENT_ONLY_RE = re.compile(r"^[ \t]*--")
CONTINUATION_SUFFIXES = (
    "(",
    "[",
    "{",
    ",",
    ":=",
    "=>",
    "->",
    "→",
    "=",
    "+",
    "-",
    "*",
    "/",
    "&&",
    "||",
    "and",
    "or",
    "do",
    "by",
    "then",
    "else",
    "match",
    "with",
    "where",
    "in",
    "|",
)


class OutputSyncError(RuntimeError):
    """Raised when generated output cannot be derived unambiguously."""


@dataclass(frozen=True)
class HashCommand:
    name: str
    start_line: int  # zero-based
    end_line: int  # zero-based, inclusive
    indent: str
    normalized_code: str


@dataclass(frozen=True)
class MintedBlock:
    begin_line: int  # zero-based line containing \begin{minted}
    body_start: int  # zero-based, inclusive
    body_end: int  # zero-based, exclusive; line containing \end{minted}
    language: str


@dataclass(frozen=True)
class LeanMessage:
    line: int  # one-based Lean source line
    data: str


def indentation_width(text: str) -> int:
    return len(text.expandtabs(2))


def delimiter_balance(text: str) -> int:
    """Count bracket nesting outside string and simple character literals."""
    balance = 0
    in_string = False
    escaped = False
    pairs = {"(": 1, "[": 1, "{": 1, ")": -1, "]": -1, "}": -1}
    index = 0

    while index < len(text):
        char = text[index]
        if escaped:
            escaped = False
            index += 1
            continue
        if in_string:
            if char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue
        if char == '"':
            in_string = True
            index += 1
            continue
        if char == "'":
            # Lean identifiers commonly end in apostrophes. Treat a quote as a
            # character literal only when a matching quote occurs immediately
            # after one character or one escaped character.
            char_end = index + 2
            if index + 1 < len(text) and text[index + 1] == "\\":
                char_end = index + 3
            if char_end < len(text) and text[char_end] == "'":
                index = char_end + 1
                continue
        balance += pairs.get(char, 0)
        index += 1
    return balance


def line_requires_continuation(text: str, balance: int) -> bool:
    stripped = text.rstrip()
    if balance > 0:
        return True
    if not stripped:
        return True
    lowered = stripped.lower()
    return any(lowered.endswith(suffix) for suffix in CONTINUATION_SUFFIXES)


def find_hash_commands(code: str) -> list[HashCommand]:
    """Find top-level ``#...`` commands while retaining multiline spans."""
    uncommented = strip_lean_comments(code)
    raw_lines = code.splitlines()
    clean_lines = uncommented.splitlines()
    # ``splitlines`` drops a final empty line consistently for both strings.
    if len(clean_lines) < len(raw_lines):
        clean_lines.extend([""] * (len(raw_lines) - len(clean_lines)))

    commands: list[HashCommand] = []
    index = 0
    while index < len(clean_lines):
        line = clean_lines[index]
        match = HASH_COMMAND_RE.match(line)
        if match is None:
            index += 1
            continue

        start = index
        end = index
        base_indent = indentation_width(match.group("indent"))
        balance = delimiter_balance(line)
        continuation = line_requires_continuation(line, balance)

        while end + 1 < len(clean_lines):
            next_line = clean_lines[end + 1]
            stripped = next_line.strip()
            if not stripped:
                if balance > 0 or continuation:
                    end += 1
                    continue
                break

            next_indent = indentation_width(next_line[: len(next_line) - len(next_line.lstrip())])
            if balance <= 0 and not continuation and next_indent <= base_indent:
                break

            end += 1
            balance += delimiter_balance(next_line)
            continuation = line_requires_continuation(next_line, balance)

        command_text = "\n".join(clean_lines[start : end + 1])
        normalized = " ".join(command_text.split())
        commands.append(
            HashCommand(
                name=match.group("name"),
                start_line=start,
                end_line=end,
                indent=match.group("indent"),
                normalized_code=normalized,
            )
        )
        index = end + 1

    return commands


def extract_minted_blocks(lines: list[str]) -> list[MintedBlock]:
    blocks: list[MintedBlock] = []
    language: str | None = None
    begin_line = -1

    for index, line in enumerate(lines):
        if language is None:
            match = BEGIN_RE.search(line)
            if match is not None:
                language = match.group(1).strip().lower()
                begin_line = index
            continue

        if END_RE.search(line):
            if language in LEAN_LANGS:
                blocks.append(
                    MintedBlock(
                        begin_line=begin_line,
                        body_start=begin_line + 1,
                        body_end=index,
                        language=language,
                    )
                )
            language = None
            begin_line = -1

    if language is not None:
        raise OutputSyncError(f"line {begin_line + 1}: minted block is not closed")
    return blocks


def line_comment_index(line: str) -> int | None:
    """Return the start of a Lean line comment, ignoring quoted ``--`` text."""
    in_string = False
    escaped = False
    index = 0
    while index + 1 < len(line):
        char = line[index]
        if escaped:
            escaped = False
            index += 1
            continue
        if in_string:
            if char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue
        if char == '"':
            in_string = True
            index += 1
            continue
        if char == "-" and line[index + 1] == "-":
            return index
        index += 1
    return None


def remove_generated_output_lines(lines: list[str]) -> list[str]:
    """Remove generated comments and legacy hand-written ``-- =>`` hints."""
    cleaned: list[str] = []
    index = 0
    while index < len(lines):
        line = lines[index]
        if GENERATED_START_RE.match(line):
            index += 1
            while index < len(lines) and GENERATED_CONTINUATION_RE.match(lines[index]):
                index += 1
            continue

        legacy = LEGACY_OUTPUT_RE.match(line)
        if legacy is not None:
            index += 1
            if not legacy.group("value").strip():
                while index < len(lines) and COMMENT_ONLY_RE.match(lines[index]):
                    index += 1
            continue

        comment_index = line_comment_index(line)
        if comment_index is not None:
            comment = line[comment_index:]
            if LEGACY_OUTPUT_RE.match(comment):
                line = line[:comment_index].rstrip()

        cleaned.append(line)
        index += 1
    return cleaned


def normalize_output(data: str) -> str:
    lines = [line.rstrip() for line in data.replace("\r\n", "\n").replace("\r", "\n").split("\n")]
    while lines and not lines[0]:
        lines.pop(0)
    while lines and not lines[-1]:
        lines.pop()
    return "\n".join(lines)


def parse_json_messages(stdout: str, source: Path) -> tuple[list[LeanMessage], list[str]]:
    messages: list[LeanMessage] = []
    non_json_lines: list[str] = []

    for raw_line in stdout.splitlines():
        if not raw_line.strip():
            continue
        try:
            payload = json.loads(raw_line)
        except json.JSONDecodeError:
            non_json_lines.append(raw_line)
            continue
        if not isinstance(payload, dict) or payload.get("severity") != "information":
            continue
        position = payload.get("pos")
        data = payload.get("data")
        if not isinstance(position, dict) or not isinstance(position.get("line"), int):
            raise OutputSyncError(f"{source}: Lean JSON message has no source line: {raw_line}")
        if not isinstance(data, str):
            raise OutputSyncError(f"{source}: Lean JSON message has non-text data: {raw_line}")
        normalized = normalize_output(data)
        if normalized:
            messages.append(LeanMessage(line=position["line"], data=normalized))

    return messages, non_json_lines


def run_and_collect_outputs(lean_path: Path, lean: str, lake: str) -> dict[int, list[str]]:
    completed = run_lean_file(lean_path, lean, lake, json_output=True)
    if completed.returncode != 0:
        details = "\n".join(part for part in (completed.stdout, completed.stderr) if part)
        raise OutputSyncError(f"{lean_path.relative_to(ROOT)}: Lean execution failed\n{details}")

    messages, non_json_lines = parse_json_messages(completed.stdout, lean_path)
    if non_json_lines:
        preview = "\n".join(non_json_lines[:10])
        raise OutputSyncError(
            f"{lean_path.relative_to(ROOT)}: Lean emitted non-JSON stdout while --json was active; "
            f"cannot map it safely to a command\n{preview}"
        )
    if completed.stderr.strip():
        raise OutputSyncError(
            f"{lean_path.relative_to(ROOT)}: Lean emitted stderr while collecting outputs\n"
            f"{completed.stderr}"
        )

    outputs: dict[int, list[str]] = {}
    for message in messages:
        outputs.setdefault(message.line, []).append(message.data)
    return outputs


def command_outputs_for_source(
    lean_path: Path,
    lean: str,
    lake: str,
) -> list[tuple[HashCommand, list[str]]]:
    source = lean_path.read_text(encoding="utf-8")
    commands = find_hash_commands(source)
    if not commands:
        return []
    messages_by_line = run_and_collect_outputs(lean_path, lean, lake)
    return [(command, messages_by_line.get(command.start_line + 1, [])) for command in commands]


def annotate_source_file(
    lean_path: Path,
    source_commands: list[tuple[HashCommand, list[str]]],
) -> tuple[str, int]:
    original = lean_path.read_text(encoding="utf-8")
    had_final_newline = original.endswith("\n")
    rendered, count = annotate_block(
        original.splitlines(),
        source_commands,
        str(lean_path.relative_to(ROOT)),
    )
    generated = "\n".join(rendered)
    if had_final_newline:
        generated += "\n"
    return generated, count


def find_matching_source_command(
    tex_command: HashCommand,
    source_commands: list[tuple[HashCommand, list[str]]],
    start_index: int,
) -> tuple[int, list[str]]:
    for index in range(start_index, len(source_commands)):
        source_command, outputs = source_commands[index]
        if source_command.normalized_code == tex_command.normalized_code:
            return index, outputs
    raise OutputSyncError(
        "Lean command in TeX was not found in the matching source file: "
        f"{tex_command.normalized_code}"
    )


def output_comment_lines(indent: str, outputs: Iterable[str]) -> list[str]:
    output_lines: list[str] = []
    for output in outputs:
        output_lines.extend(output.split("\n"))

    if len(output_lines) == 1:
        return [f"{indent}{OUTPUT_MARKER} {output_lines[0]}"]

    rendered = [f"{indent}{OUTPUT_MARKER}"]
    for line in output_lines:
        rendered.append(f"{indent}{OUTPUT_CONTINUATION}{line}" if line else f"{indent}--")
    return rendered


def annotate_block(
    block_lines: list[str],
    source_commands: list[tuple[HashCommand, list[str]]],
    source_name: str,
) -> tuple[list[str], int]:
    cleaned = remove_generated_output_lines(block_lines)
    tex_commands = find_hash_commands("\n".join(cleaned))
    inserts: dict[int, list[str]] = {}
    source_cursor = 0
    annotation_count = 0

    for tex_command in tex_commands:
        source_index, outputs = find_matching_source_command(
            tex_command,
            source_commands,
            source_cursor,
        )
        source_cursor = source_index + 1
        if not outputs:
            if tex_command.name in REQUIRED_OUTPUT_COMMANDS:
                raise OutputSyncError(
                    f"{source_name}: {tex_command.normalized_code} produced no informational output"
                )
            continue
        inserts[tex_command.end_line] = output_comment_lines(tex_command.indent, outputs)
        annotation_count += 1

    rendered: list[str] = []
    for index, line in enumerate(cleaned):
        rendered.append(line)
        rendered.extend(inserts.get(index, []))
    return rendered, annotation_count


def sync_tex_file(
    tex_path: Path,
    lean: str,
    lake: str,
) -> tuple[dict[Path, str], int]:
    original = tex_path.read_text(encoding="utf-8")
    had_final_newline = original.endswith("\n")
    lines = original.splitlines()
    blocks = extract_minted_blocks(lines)
    lean_paths = matching_lean_paths(tex_path)

    if len(blocks) != len(lean_paths):
        raise OutputSyncError(
            f"{tex_path.relative_to(ROOT)}: {len(blocks)} Lean block(s) but "
            f"{len(lean_paths)} matching snippet file(s)"
        )

    generated_files: dict[Path, str] = {}
    replacements: list[tuple[int, int, list[str]]] = []
    annotation_count = 0
    for block, lean_path in zip(blocks, lean_paths, strict=True):
        if not lean_path.exists():
            raise OutputSyncError(f"{lean_path.relative_to(ROOT)}: matching Lean file is missing")
        source_commands = command_outputs_for_source(lean_path, lean, lake)
        generated_source, _source_count = annotate_source_file(lean_path, source_commands)
        generated_files[lean_path] = generated_source

        replacement, tex_count = annotate_block(
            lines[block.body_start : block.body_end],
            source_commands,
            str(lean_path.relative_to(ROOT)),
        )
        replacements.append((block.body_start, block.body_end, replacement))
        annotation_count += tex_count

    for start, end, replacement in reversed(replacements):
        lines[start:end] = replacement

    generated_tex = "\n".join(lines)
    if had_final_newline:
        generated_tex += "\n"
    generated_files[tex_path] = generated_tex
    return generated_files, annotation_count


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", help="Optional chapter .tex files to update or check.")
    parser.add_argument(
        "--check",
        action="store_true",
        help="Do not write files; fail if generated Lean output comments are stale or missing.",
    )
    parser.add_argument("--lean", default=str(Path.home() / ".elan" / "bin" / "lean"))
    parser.add_argument("--lake", default=str(Path.home() / ".elan" / "bin" / "lake"))
    args = parser.parse_args()

    tex_files = chapter_tex_files(args.paths)
    changed: list[Path] = []
    total_annotations = 0
    try:
        for tex_path in tex_files:
            if not tex_path.exists():
                raise OutputSyncError(f"{tex_path}: file does not exist")
            generated_files, count = sync_tex_file(tex_path, args.lean, args.lake)
            total_annotations += count
            for path, generated in generated_files.items():
                original = path.read_text(encoding="utf-8")
                if generated == original:
                    continue
                changed.append(path)
                if not args.check:
                    path.write_text(generated, encoding="utf-8")
    except OutputSyncError as error:
        print(f"Lean command output sync failed: {error}", file=sys.stderr)
        return 1

    changed = sorted(set(changed))

    if args.check and changed:
        print("Lean command output annotations are stale or missing:", file=sys.stderr)
        for path in changed:
            print(f"- {path.relative_to(ROOT)}", file=sys.stderr)
        print("Run: python3 tools/sync_lean_command_outputs.py", file=sys.stderr)
        return 1

    action = "checked" if args.check else "updated"
    print(
        f"Lean command output annotations {action}: "
        f"{total_annotations} command(s) across {len(tex_files)} chapter file(s); "
        f"{len(changed)} file(s) changed"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
