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

-- 0 を足す税計算は、元の金額と同じ。
theorem addTax_zero (n : Nat) :
    addTax n 0 = n := by
  unfold addTax
  rw [Nat.add_zero]

-- 既存コードには、不要な 0 税計算が残っているとする。
def normalizedPrice (base discount : Nat) : Nat :=
  addTax (subtotal base discount) 0

-- その不要な処理を仕様に基づいて取り除く。
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

-- この補題は simp が自動で使えるようにしておく。
@[simp] theorem addTax_zero_simp (n : Nat) :
    addTax n 0 = n := by
  unfold addTax
  simp

-- 何もしない正規化処理を、あえて関数として置く。
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

def chargeLegacy
    (base discount service shipping : Nat) : Nat :=
  addTax
    (addFee (addFee (subtotal base discount) service) shipping)
    0

def chargeNormalized
    (base discount service shipping : Nat) : Nat :=
  (base - discount) + (service + shipping)

theorem chargeLegacy_eq_chargeNormalized
    (base discount service shipping : Nat) :
    chargeLegacy base discount service shipping =
      chargeNormalized base discount service shipping := by
  unfold chargeLegacy chargeNormalized subtotal addFee addTax
  simp [Nat.add_assoc]

end Ch12
