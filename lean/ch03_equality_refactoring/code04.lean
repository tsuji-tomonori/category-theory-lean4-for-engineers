-- Source: chapters/ch03_equality_refactoring.tex:207
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

-- rw は、既知の等式を使った置換として読める。
def addFeeOriginal (price fee : Nat) : Nat :=
  price + fee

def addFeeRefactored (price fee : Nat) : Nat :=
  fee + price

theorem addFee_refactor_preserves (price fee : Nat) :
    addFeeOriginal price fee = addFeeRefactored price fee := by
  unfold addFeeOriginal addFeeRefactored
  rw [Nat.add_comm]
