-- Source: chapters/ch20_price_spec.tex:107

import Std

namespace Chapter20

/-- この章では、金額を最小通貨単位の自然数として単純化する。 -/
abbrev Money := Nat

/-- 割引を適用する。Lean の Nat の引き算は 0 で止まる。 -/
def applyDiscount (discount amount : Money) : Money :=
  amount - discount

/-- 固定手数料を加える。 -/
def addFee (fee amount : Money) : Money :=
  amount + fee

/-- 固定額として表した税を加える。 -/
def addFixedTax (tax amount : Money) : Money :=
  amount + tax

/-- 率に基づく税額。割り算は整数除算なので、ここに丸めが入る。 -/
def taxOnly (rateNum rateDen amount : Money) : Money :=
  (amount * rateNum) / rateDen

/-- 率に基づく税額を加える。 -/
def addRateTax (rateNum rateDen amount : Money) : Money :=
  amount + taxOnly rateNum rateDen amount
