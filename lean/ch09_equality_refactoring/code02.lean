-- 出典: chapters/ch09_equality_refactoring.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter09

def rawCalc (x : Nat) : Nat :=
  (x + 0) * 1

def refactoredCalc (x : Nat) : Nat :=
  x

theorem rawCalc_eq_refactoredCalc (x : Nat) :
    rawCalc x = refactoredCalc x := by
  unfold rawCalc refactoredCalc
  simp

def sameOnNat (f g : Nat → Nat) : Prop :=
  ∀ x, f x = g x

theorem raw_and_refactored_same :
    sameOnNat rawCalc refactoredCalc := by
  intro x
  unfold rawCalc refactoredCalc
  simp
