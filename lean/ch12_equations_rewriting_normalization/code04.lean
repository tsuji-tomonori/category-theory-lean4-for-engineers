-- 出典: chapters/ch12_equations_rewriting_normalization.tex:166
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch12

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
