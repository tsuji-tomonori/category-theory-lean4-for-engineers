-- Source: chapters/ch12_equations_rewriting_normalization.tex:144

theorem subtotal_eq_normalizedPrice
    (base discount : Nat) :
    subtotal base discount =
      normalizedPrice base discount := by
  rw [normalizedPrice_eq_subtotal]
