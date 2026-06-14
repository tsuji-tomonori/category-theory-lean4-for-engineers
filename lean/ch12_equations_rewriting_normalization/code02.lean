-- Source: chapters/ch12_equations_rewriting_normalization.tex:114

-- 0 を足す税計算は、元の金額と同じ。
theorem addTax_zero (n : Nat) :
    addTax n 0 = n := by
  unfold addTax
  rw [Nat.add_zero]

-- 既存コードには、不要な 0 税計算が残っているとする。
def normalizedPrice (base discount : Nat) : Nat :=
  addTax (subtotal base discount) 0

-- その不要な処理を仕様に基づいて取り除く。
theorem normalizedPrice_eq_subtotal
    (base discount : Nat) :
    normalizedPrice base discount =
      subtotal base discount := by
  unfold normalizedPrice
  rw [addTax_zero]
