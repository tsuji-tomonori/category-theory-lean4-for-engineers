-- Source: chapters/ch07_products_coproducts.tex:275

theorem makePair_unique_pointwise {A B C : Type}
    (f : C → A) (g : C → B) (h : C → A × B)
    (hfst : ∀ c, (h c).1 = f c)
    (hsnd : ∀ c, (h c).2 = g c)
    (c : C) : h c = makePair f g c := by
  calc
    h c = ((h c).1, (h c).2) := by
      cases h c
      rfl
    _ = (f c, g c) := by
      rw [hfst c, hsnd c]
    _ = makePair f g c := rfl
