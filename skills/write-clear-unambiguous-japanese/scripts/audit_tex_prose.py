#!/usr/bin/env python3
"""Inventory Japanese prose in LaTeX files and flag review candidates."""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path


JAPANESE = re.compile(r"[ぁ-んァ-ヶ一-龠々〆ヵヶ]")
SENTENCE_END = re.compile(r"(?<=[。！？])")
CODE_ENVIRONMENTS = re.compile(
    r"\\begin\{(?:lstlisting|verbatim|Verbatim|LeanCode)\}.*?"
    r"\\end\{(?:lstlisting|verbatim|Verbatim|LeanCode)\}",
    re.DOTALL,
)
DISPLAY_MATH = re.compile(r"\\\[.*?\\\]|\$\$.*?\$\$", re.DOTALL)
INLINE_MATH = re.compile(r"(?<!\\)\$.*?(?<!\\)\$")
COMMAND_WITH_ARGUMENT = re.compile(
    r"\\(?:label|ref|pageref|eqref|cite|url|href|path|input|includegraphics)"
    r"(?:\[[^\]]*\])?\{[^{}]*\}"
)
LATEX_COMMAND = re.compile(r"\\[A-Za-z@]+\*?(?:\[[^\]]*\])?")


@dataclass(frozen=True)
class Finding:
    path: Path
    line: int
    reason: str
    text: str


def mask_protected(text: str) -> str:
    text = CODE_ENVIRONMENTS.sub("\n", text)
    text = DISPLAY_MATH.sub(" ", text)
    text = INLINE_MATH.sub(" ", text)
    text = COMMAND_WITH_ARGUMENT.sub(" ", text)
    text = LATEX_COMMAND.sub(" ", text)
    text = re.sub(r"(?m)(?<!\\)%.*$", "", text)
    text = text.replace("{", " ").replace("}", " ")
    return text


def iter_sentences(path: Path) -> list[tuple[int, str]]:
    raw = path.read_text(encoding="utf-8")
    prose = mask_protected(raw)
    sentences: list[tuple[int, str]] = []
    # This repository keeps prose sentences and table rows on separate lines.
    # Treating a newline as a boundary prevents headings, tables, and the next
    # paragraph from being concatenated into one false long-sentence finding.
    for line_number, source_line in enumerate(prose.splitlines(), start=1):
        for part in SENTENCE_END.split(source_line):
            clean = re.sub(r"\s+", " ", part).strip()
            if clean and JAPANESE.search(clean):
                sentences.append((line_number, clean))
    return sentences


def inspect(path: Path, line: int, sentence: str) -> list[Finding]:
    findings: list[Finding] = []
    japanese_length = len(JAPANESE.findall(sentence))
    if japanese_length >= 100:
        findings.append(Finding(path, line, f"長文:{japanese_length}字", sentence))
    demonstratives = re.findall(r"(?:これ|それ|あれ|この|その|あの)(?!ため|よう|とき)", sentence)
    if demonstratives:
        findings.append(Finding(path, line, "指示語:" + ",".join(demonstratives), sentence))
    limiters = re.findall(r"(?:のみ|だけ|すべて|全て)", sentence)
    if limiters:
        findings.append(Finding(path, line, "限定範囲:" + ",".join(limiters), sentence))
    connectives = re.findall(r"(?:しかし|一方で|とはいえ|ただし|または|あるいは)", sentence)
    if len(connectives) >= 2:
        findings.append(Finding(path, line, "接続過多:" + ",".join(connectives), sentence))
    hard_forms = re.findall(r"(?:漸く|繋[ぐぎい]|遵守|俊敏性|等々|等を|等が)", sentence)
    if hard_forms:
        findings.append(Finding(path, line, "難表記:" + ",".join(hard_forms), sentence))
    return findings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+", type=Path)
    args = parser.parse_args()

    total_sentences = 0
    all_findings: list[Finding] = []
    for path in args.paths:
        sentences = iter_sentences(path)
        total_sentences += len(sentences)
        for line, sentence in sentences:
            all_findings.extend(inspect(path, line, sentence))

    print(f"files\t{len(args.paths)}")
    print(f"sentences\t{total_sentences}")
    print(f"review_candidates\t{len(all_findings)}")
    for item in all_findings:
        print(f"{item.path}:{item.line}\t{item.reason}\t{item.text}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
