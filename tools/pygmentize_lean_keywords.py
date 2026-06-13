#!/usr/bin/env python3
"""Run Pygments with the book's Lean proof keywords highlighted consistently."""

from __future__ import annotations

import sys

from pygments.cmdline import main
from pygments.lexers.lean import Lean4Lexer
from pygments.lexer import words


LEAN_PROOF_KEYWORDS = ("rfl", "simp", "rw")


def patch_lean4_keywords() -> None:
    """Treat common proof tactics as keywords in rendered Lean snippets."""
    for keyword in LEAN_PROOF_KEYWORDS:
        if keyword not in Lean4Lexer.keywords2:
            Lean4Lexer.keywords2 = Lean4Lexer.keywords2 + (keyword,)
    proof_keyword_rule = (
        words(LEAN_PROOF_KEYWORDS, prefix=r"\b", suffix=r"\b"),
        Lean4Lexer.tokens["root"][1][1],
    )
    Lean4Lexer.tokens["root"][1] = (
        words(Lean4Lexer.keywords2, prefix=r"\b", suffix=r"\b"),
        Lean4Lexer.tokens["root"][1][1],
    )
    if proof_keyword_rule not in Lean4Lexer.tokens["expression"]:
        Lean4Lexer.tokens["expression"].insert(6, proof_keyword_rule)


if __name__ == "__main__":
    patch_lean4_keywords()
    sys.exit(main(sys.argv))
