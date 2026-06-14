-- Source: chapters/ch07_products_coproducts.tex:302

-- Coproduct universal-property shape, in a small pointwise form.
def eitherElim {A B C : Type} (f : A → C) (g : B → C)
    (s : Sum A B) : C :=
  match s with
  | Sum.inl a => f a
  | Sum.inr b => g b

theorem eitherElim_inl {A B C : Type}
    (f : A → C) (g : B → C) (a : A) :
    eitherElim f g (Sum.inl a) = f a := rfl

theorem eitherElim_inr {A B C : Type}
    (f : A → C) (g : B → C) (b : B) :
    eitherElim f g (Sum.inr b) = g b := rfl
