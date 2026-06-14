-- Source: chapters/ch20_price_spec.tex:199

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
