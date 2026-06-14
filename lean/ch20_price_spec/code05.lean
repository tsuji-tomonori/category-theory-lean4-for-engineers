-- Source: chapters/ch20_price_spec.tex:244

/-- 割引後に足すだけの処理は、順序を入れ替えても合計が変わらない。 -/
theorem total_refactor_safe (base discount fee tax : Money) :
    totalV1 base discount fee tax = totalV2 base discount fee tax := by
  unfold totalV1 totalV2 addFixedTax addFee applyDiscount
  exact Nat.add_right_comm (base - discount) fee tax
