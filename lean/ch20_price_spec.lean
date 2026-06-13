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

/-- 固定税と固定手数料は、ともに加算なので順序を入れ替えられる。 -/
theorem fee_tax_commute (amount fee tax : Money) :
    addFee fee (addFixedTax tax amount)
      = addFixedTax tax (addFee fee amount) := by
  unfold addFee addFixedTax
  exact Nat.add_right_comm amount tax fee

/-- 先に割引してから手数料を足す計算。 -/
def discountThenFee (amount discount fee : Money) : Money :=
  addFee fee (applyDiscount discount amount)

/-- 先に手数料を足してから割引する計算。 -/
def feeThenDiscount (amount discount fee : Money) : Money :=
  applyDiscount discount (addFee fee amount)

/-- 割引と手数料は、一般には順序を入れ替えられない。 -/
theorem discount_fee_order_counterexample :
    discountThenFee 500 1000 100 ≠ feeThenDiscount 500 1000 100 := by
  decide

/-- 仕様上の標準順序：割引、手数料、固定税の順。 -/
def totalV1 (base discount fee tax : Money) : Money :=
  addFixedTax tax (addFee fee (applyDiscount discount base))

/-- リファクタリング後：割引後の金額に、固定税と手数料を逆順で加える。 -/
def totalV2 (base discount fee tax : Money) : Money :=
  addFee fee (addFixedTax tax (applyDiscount discount base))

/-- 割引後に足すだけの処理は、順序を入れ替えても合計が変わらない。 -/
theorem total_refactor_safe (base discount fee tax : Money) :
    totalV1 base discount fee tax = totalV2 base discount fee tax := by
  unfold totalV1 totalV2 addFixedTax addFee applyDiscount
  exact Nat.add_right_comm (base - discount) fee tax

/-- `calc` を使うと、レビュー可能な等式変形として読める。 -/
theorem total_refactor_safe_calc (base discount fee tax : Money) :
    totalV1 base discount fee tax = totalV2 base discount fee tax := by
  unfold totalV1 totalV2 addFixedTax addFee applyDiscount
  calc
    (base - discount + fee) + tax
        = (base - discount + tax) + fee := by
            exact Nat.add_right_comm (base - discount) fee tax

/-- 割引は金額を増やさない。 -/
theorem discount_never_increases (amount discount : Money) :
    applyDiscount discount amount ≤ amount := by
  unfold applyDiscount
  exact Nat.sub_le amount discount

/-- 固定手数料は金額を減らさない。 -/
theorem addFee_never_decreases (amount fee : Money) :
    amount ≤ addFee fee amount := by
  unfold addFee
  exact Nat.le_add_right amount fee

/-- 標準順序の合計は、割引直後の金額以上である。 -/
theorem total_ge_discounted (base discount fee tax : Money) :
    applyDiscount discount base ≤ totalV1 base discount fee tax := by
  unfold totalV1 addFixedTax addFee
  exact Nat.le_trans
    (Nat.le_add_right (applyDiscount discount base) fee)
    (Nat.le_add_right (applyDiscount discount base + fee) tax)

/-- 2明細をそれぞれ丸める場合の税額。ここでは 10% を 1/10 として表す。 -/
def taxPerLine2 (a b : Money) : Money :=
  taxOnly 1 10 a + taxOnly 1 10 b

/-- 2明細を合算してから丸める場合の税額。 -/
def taxOnSum2 (a b : Money) : Money :=
  taxOnly 1 10 (a + b)

#eval taxPerLine2 9 9
#eval taxOnSum2 9 9

/-- 丸めの位置は、一般には入れ替えられない。 -/
theorem rounding_position_counterexample :
    taxPerLine2 9 9 ≠ taxOnSum2 9 9 := by
  decide

end Chapter20
