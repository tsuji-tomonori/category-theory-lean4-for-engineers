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

theorem addTax_zero (n : Nat) :
    addTax n 0 = n := by
  unfold addTax
  rw [Nat.add_zero]

def normalizedPrice (base discount : Nat) : Nat :=
  addTax (subtotal base discount) 0

theorem normalizedPrice_eq_subtotal
    (base discount : Nat) :
    normalizedPrice base discount =
      subtotal base discount := by
  unfold normalizedPrice
  rw [addTax_zero]

theorem subtotal_eq_normalizedPrice
    (base discount : Nat) :
    subtotal base discount =
      normalizedPrice base discount := by
  rw [normalizedPrice_eq_subtotal]

@[simp] theorem addTax_zero_simp (n : Nat) :
    addTax n 0 = n := by
  unfold addTax
  simp

def normalizeCode (n : Nat) : Nat :=
  n + 0

def loadCode (n : Nat) : Nat :=
  normalizeCode (normalizeCode n)

@[simp] theorem normalizeCode_eq (n : Nat) :
    normalizeCode n = n := by
  unfold normalizeCode
  simp

theorem loadCode_normalized (n : Nat) :
    loadCode n = n := by
  simp [loadCode]

def addFee (amount fee : Nat) : Nat :=
  amount + fee

def legacyWithTwoFees
    (base service shipping : Nat) : Nat :=
  addFee (addFee base service) shipping

def refactoredWithTwoFees
    (base service shipping : Nat) : Nat :=
  addFee base (service + shipping)

theorem twoFees_eq_calc
    (base service shipping : Nat) :
    legacyWithTwoFees base service shipping =
      refactoredWithTwoFees base service shipping := by
  calc
    legacyWithTwoFees base service shipping
        = (base + service) + shipping := by rfl
    _ = base + (service + shipping) := by
          rw [Nat.add_assoc]
    _ = refactoredWithTwoFees base service shipping := by rfl
