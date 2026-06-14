-- Source: chapters/ch20_price_spec.tex:175

/-- 固定税と固定手数料は、ともに加算なので順序を入れ替えられる。 -/
theorem fee_tax_commute (amount fee tax : Money) :
    addFee fee (addFixedTax tax amount)
      = addFixedTax tax (addFee fee amount) := by
  unfold addFee addFixedTax
  exact Nat.add_right_comm amount tax fee
