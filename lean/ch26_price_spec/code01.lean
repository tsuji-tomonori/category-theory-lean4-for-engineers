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
