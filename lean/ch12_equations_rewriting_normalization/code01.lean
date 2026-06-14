-- Source: chapters/ch12_equations_rewriting_normalization.tex:67

/-
第12章 等式・書き換え・正規化
Lean 4 examples for the chapter.
This file intentionally uses only small Nat-based models.
-/

namespace Ch12

-- 割引後の小計。Nat の引き算は 0 で止まる。
def subtotal (base discount : Nat) : Nat :=
  base - discount

-- 税や手数料を加える単純な処理。
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
