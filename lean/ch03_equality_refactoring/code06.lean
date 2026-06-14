-- 出典: chapters/ch03_equality_refactoring.tex:287
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch03EqualityRefactoring

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

def addFeeOriginal (price fee : Nat) : Nat :=
  price + fee

def addFeeRefactored (price fee : Nat) : Nat :=
  fee + price

theorem addFee_refactor_preserves (price fee : Nat) :
    addFeeOriginal price fee = addFeeRefactored price fee := by
  unfold addFeeOriginal addFeeRefactored
  rw [Nat.add_comm]

def totalOriginal (price qty shipping handling : Nat) : Nat :=
  ((price * qty) + shipping) + handling

def totalExtracted (price qty shipping handling : Nat) : Nat :=
  let subtotal := price * qty
  let extra := shipping + handling
  subtotal + extra

theorem total_extracted_preserves
    (price qty shipping handling : Nat) :
    totalOriginal price qty shipping handling =
      totalExtracted price qty shipping handling := by
  unfold totalOriginal totalExtracted
  calc
    ((price * qty) + shipping) + handling
        = (price * qty) + (shipping + handling) := by
          rw [Nat.add_assoc]

def addShipping (n : Nat) : Nat :=
  n + 500

def addHandling (n : Nat) : Nat :=
  n + 100

theorem add_steps_commute (n : Nat) :
    addHandling (addShipping n) = addShipping (addHandling n) := by
  unfold addHandling addShipping
  calc
    (n + 500) + 100 = n + (500 + 100) := by
      rw [Nat.add_assoc]
    _ = n + (100 + 500) := by
      rw [Nat.add_comm 500 100]
    _ = (n + 100) + 500 := by
      rw [← Nat.add_assoc]

def discount100 (n : Nat) : Nat :=
  n - 100

#eval discount100 (addShipping 50)
#eval addShipping (discount100 50)

end Ch03EqualityRefactoring
