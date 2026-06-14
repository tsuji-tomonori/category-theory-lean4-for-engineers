-- 出典: chapters/ch20_price_spec.tex:199
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

import Std

namespace Chapter20

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
