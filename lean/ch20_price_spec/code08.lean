-- Source: chapters/ch20_price_spec.tex:309

/-- 標準順序の合計は、割引直後の金額以上である。 -/
theorem total_ge_discounted (base discount fee tax : Money) :
    applyDiscount discount base ≤ totalV1 base discount fee tax := by
  unfold totalV1 addFixedTax addFee
  exact Nat.le_trans
    (Nat.le_add_right (applyDiscount discount base) fee)
    (Nat.le_add_right (applyDiscount discount base + fee) tax)
