-- Source: chapters/ch07_products_coproducts.tex:256

theorem sum_option_roundtrip {A : Type} (s : Sum Unit A) :
    optionToSum (sumToOption s) = s := by
  cases s with
  | inl u =>
      cases u
      rfl
  | inr a => rfl

-- Product universal-property shape, in a small pointwise form.
def makePair {A B C : Type} (f : C → A) (g : C → B) : C → A × B :=
  fun c => (f c, g c)

theorem makePair_fst {A B C : Type}
    (f : C → A) (g : C → B) (c : C) :
    (makePair f g c).1 = f c := rfl

theorem makePair_snd {A B C : Type}
    (f : C → A) (g : C → B) (c : C) :
    (makePair f g c).2 = g c := rfl
