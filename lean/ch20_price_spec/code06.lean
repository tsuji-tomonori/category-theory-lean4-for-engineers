-- Source: chapters/ch20_price_spec.tex:261

/-- `calc` を使うと、レビュー可能な等式変形として読める。 -/
theorem total_refactor_safe_calc (base discount fee tax : Money) :
    totalV1 base discount fee tax = totalV2 base discount fee tax := by
  unfold totalV1 totalV2 addFixedTax addFee applyDiscount
  calc
    (base - discount + fee) + tax
        = (base - discount + tax) + fee := by
            exact Nat.add_right_comm (base - discount) fee tax
