-- Source: chapters/app_c_property_patterns.tex:186

def SpecLe {A : Type} (p q : A -> Prop) : Prop :=
  forall x, p x -> q x

theorem SpecLe_refl {A : Type} (p : A -> Prop) :
    SpecLe p p := by
  intro x hx
  exact hx

theorem SpecLe_trans {A : Type} (p q r : A -> Prop) :
    SpecLe p q -> SpecLe q r -> SpecLe p r := by
  intro hpq hqr x hx
  exact hqr x (hpq x hx)
