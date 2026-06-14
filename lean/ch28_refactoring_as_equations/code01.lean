-- Source: chapters/ch28_refactoring_as_equations.tex:42

/-
Chapter 28: リファクタリングを等式として扱う

This file contains the Lean 4 snippets used in the chapter.
It avoids Mathlib-specific APIs and uses small standard-library examples.
-/

namespace Chapter28

-- 関数抽出: 補助関数を導入しても計算結果が同じであることを示す。
def basePrice (subtotal shipping : Nat) : Nat :=
  subtotal + shipping

def tax10 (n : Nat) : Nat :=
  n / 10

def totalBefore (subtotal shipping : Nat) : Nat :=
  (subtotal + shipping) + ((subtotal + shipping) / 10)

def totalAfter (subtotal shipping : Nat) : Nat :=
  let base := basePrice subtotal shipping
  base + tax10 base

theorem extract_base_price_preserves (subtotal shipping : Nat) :
    totalAfter subtotal shipping = totalBefore subtotal shipping := by
  rfl
