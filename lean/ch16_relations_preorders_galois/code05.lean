-- Source: chapters/ch16_relations_preorders_galois.tex:197

-- p が q より強いとは、p を満たせば q も満たすということ。
def Stronger {A : Type} (p q : A -> Prop) : Prop :=
  forall x, p x -> q x

theorem stronger_refl {A : Type} (p : A -> Prop) :
    Stronger p p := by
  intro x hx
  exact hx

theorem stronger_trans {A : Type} {p q r : A -> Prop} :
    Stronger p q -> Stronger q r -> Stronger p r := by
  intro hpq hqr x hpx
  exact hqr x (hpq x hpx)
