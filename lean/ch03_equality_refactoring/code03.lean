-- Source: chapters/ch03_equality_refactoring.tex:141

-- rw は、既知の等式を使った置換として読める。
def addFeeOriginal (price fee : Nat) : Nat :=
  price + fee

def addFeeRefactored (price fee : Nat) : Nat :=
  fee + price

theorem addFee_refactor_preserves (price fee : Nat) :
    addFeeOriginal price fee = addFeeRefactored price fee := by
  unfold addFeeOriginal addFeeRefactored
  rw [Nat.add_comm]

-- calc は、レビューしやすい段階的な式変形である。
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
