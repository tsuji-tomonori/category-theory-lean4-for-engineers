-- 出典: chapters/ch28_refactoring_as_equations.tex:42
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter28

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
