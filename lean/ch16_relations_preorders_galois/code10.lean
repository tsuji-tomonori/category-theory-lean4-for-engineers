-- Source: chapters/ch16_relations_preorders_galois.tex:369

theorem gc_unit {C A : Type} {cLe : C -> C -> Prop} {aLe : A -> A -> Prop}
    {alpha : C -> A} {gamma : A -> C}
    (gc : GaloisConnectionMini C A cLe aLe alpha gamma)
    (a_refl : forall a, aLe a a) :
    forall c, cLe c (gamma (alpha c)) := by
  intro c
  exact (gc.law c (alpha c)).mp (a_refl (alpha c))

theorem gc_counit {C A : Type} {cLe : C -> C -> Prop} {aLe : A -> A -> Prop}
    {alpha : C -> A} {gamma : A -> C}
    (gc : GaloisConnectionMini C A cLe aLe alpha gamma)
    (c_refl : forall c, cLe c c) :
    forall a, aLe (alpha (gamma a)) a := by
  intro a
  exact (gc.law (gamma a) a).mpr (c_refl (gamma a))
