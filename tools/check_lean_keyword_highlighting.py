#!/usr/bin/env python3
"""Verify that the book's Lean proof tactics receive keyword highlighting."""

from __future__ import annotations

from pygments import lex
from pygments.lexers.lean import Lean4Lexer
from pygments.token import Keyword

from pygmentize_lean_keywords import LEAN_PROOF_KEYWORDS, patch_lean4_keywords


def main() -> int:
    patch_lean4_keywords()

    source = "example : True := by\n" + "".join(
        f"  {keyword}\n" for keyword in LEAN_PROOF_KEYWORDS
    )
    highlighted = {
        value
        for token_type, value in lex(source, Lean4Lexer())
        if token_type in Keyword and value in LEAN_PROOF_KEYWORDS
    }
    missing = sorted(set(LEAN_PROOF_KEYWORDS) - highlighted)
    if missing:
        print(
            "Lean proof tactics are not highlighted as keywords: "
            + ", ".join(missing)
        )
        return 1

    print(
        "Lean proof tactic highlighting is configured: "
        + ", ".join(LEAN_PROOF_KEYWORDS)
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
