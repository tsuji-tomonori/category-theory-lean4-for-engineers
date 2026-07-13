-- 出典: chapters/ch18_equations_rewriting_normalization.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter18

def subtotal (base discount : Nat) : Nat :=
  base - discount

def addTax (amount tax : Nat) : Nat :=
  amount + tax

def legacyPrice (base discount tax : Nat) : Nat :=
  addTax (subtotal base discount) tax

def refactoredPrice (base discount tax : Nat) : Nat :=
  (base - discount) + tax

#eval legacyPrice 1000 100 80
#eval refactoredPrice 1000 100 80

theorem legacy_eq_refactored
    (base discount tax : Nat) :
    legacyPrice base discount tax =
      refactoredPrice base discount tax := by
  rfl
