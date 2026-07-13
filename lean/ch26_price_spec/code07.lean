-- 出典: chapters/ch26_price_spec.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

import Std

namespace Chapter26

abbrev Money := Nat

def applyDiscount (discount amount : Money) : Money :=
  amount - discount

def addFee (fee amount : Money) : Money :=
  amount + fee

def addFixedTax (tax amount : Money) : Money :=
  amount + tax

def taxOnly (rateNum rateDen amount : Money) : Money :=
  (amount * rateNum) / rateDen

def addRateTax (rateNum rateDen amount : Money) : Money :=
  amount + taxOnly rateNum rateDen amount

theorem fee_tax_commute (amount fee tax : Money) :
    addFee fee (addFixedTax tax amount)
      = addFixedTax tax (addFee fee amount) := by
  unfold addFee addFixedTax
  exact Nat.add_right_comm amount tax fee

def discountThenFee (amount discount fee : Money) : Money :=
  addFee fee (applyDiscount discount amount)

def feeThenDiscount (amount discount fee : Money) : Money :=
  applyDiscount discount (addFee fee amount)

theorem discount_fee_order_counterexample :
    discountThenFee 500 1000 100 ≠ feeThenDiscount 500 1000 100 := by
  decide

def totalV1 (base discount fee tax : Money) : Money :=
  addFixedTax tax (addFee fee (applyDiscount discount base))

def totalV2 (base discount fee tax : Money) : Money :=
  addFee fee (addFixedTax tax (applyDiscount discount base))

theorem total_refactor_safe (base discount fee tax : Money) :
    totalV1 base discount fee tax = totalV2 base discount fee tax := by
  unfold totalV1 totalV2 addFixedTax addFee applyDiscount
  exact Nat.add_right_comm (base - discount) fee tax

theorem total_refactor_safe_calc (base discount fee tax : Money) :
    totalV1 base discount fee tax = totalV2 base discount fee tax := by
  unfold totalV1 totalV2 addFixedTax addFee applyDiscount
  calc
    (base - discount + fee) + tax
        = (base - discount + tax) + fee := by
            exact Nat.add_right_comm (base - discount) fee tax

theorem discount_never_increases (amount discount : Money) :
    applyDiscount discount amount ≤ amount := by
  unfold applyDiscount
  exact Nat.sub_le amount discount

theorem addFee_never_decreases (amount fee : Money) :
    amount ≤ addFee fee amount := by
  unfold addFee
  exact Nat.le_add_right amount fee
