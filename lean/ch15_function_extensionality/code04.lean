-- Source: chapters/ch15_function_extensionality.tex:200

-- 点ごとの等式を、特定の入力に適用する。
theorem apply_pointwise
    {α β : Type} {f g : α → β}
    (h : ∀ x : α, f x = g x) (x : α) :
    f x = g x := by
  exact h x

-- 関数そのものの等式から、点ごとの等式を得る。
theorem function_eq_to_pointwise
    {α β : Type} {f g : α → β}
    (h : f = g) :
    ∀ x : α, f x = g x := by
  intro x
  rw [h]
