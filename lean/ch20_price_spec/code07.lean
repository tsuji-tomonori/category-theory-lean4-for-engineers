-- Source: chapters/ch20_price_spec.tex:289

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
