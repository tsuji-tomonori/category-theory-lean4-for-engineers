-- Source: chapters/ch03_equality_refactoring.tex:103

-- 関数の結果が同じ、という仕様を全入力についての命題にする。
def sameOnNat (f g : Nat → Nat) : Prop :=
  ∀ x, f x = g x

theorem raw_and_refactored_same :
    sameOnNat rawCalc refactoredCalc := by
  intro x
  unfold rawCalc refactoredCalc
  simp
