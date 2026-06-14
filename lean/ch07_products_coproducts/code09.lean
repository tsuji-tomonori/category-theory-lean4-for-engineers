-- Source: chapters/ch07_products_coproducts.tex:324

theorem eitherElim_unique_pointwise {A B C : Type}
    (f : A → C) (g : B → C) (h : Sum A B → C)
    (hl : ∀ a, h (Sum.inl a) = f a)
    (hr : ∀ b, h (Sum.inr b) = g b)
    (s : Sum A B) : h s = eitherElim f g s := by
  cases s with
  | inl a =>
      rw [hl a]
      rfl
  | inr b =>
      rw [hr b]
      rfl
