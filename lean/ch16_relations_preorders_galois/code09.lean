-- Source: chapters/ch16_relations_preorders_galois.tex:331

structure GaloisConnectionMini (C A : Type)
    (cLe : C -> C -> Prop) (aLe : A -> A -> Prop)
    (alpha : C -> A) (gamma : A -> C) : Prop where
  law : forall c a, Iff (aLe (alpha c) a) (cLe c (gamma a))

-- erase と allow は Galois 接続をなす。
theorem erase_allow_galois :
    GaloisConnectionMini Detail PublicView detailLe viewLe erase allow := by
  constructor
  intro c a
  cases c <;> cases a <;> simp [erase, allow, detailLe, viewLe]
