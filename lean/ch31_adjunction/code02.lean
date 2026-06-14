-- Source: chapters/ch31_adjunction.tex:152

/-- foldMap sends list concatenation to the target monoid operation. -/
theorem foldMap_append {A M : Type}
    (mon : TinyMonoid M) (f : A -> M) :
    forall xs ys : List A,
      foldMap mon f (xs ++ ys) =
        mon.op (foldMap mon f xs) (foldMap mon f ys) := by
  intro xs
  induction xs with
  | nil =>
      intro ys
      simp [foldMap, mon.unit_left]
  | cons x xs ih =>
      intro ys
      simp [foldMap, ih, mon.assoc]

/-- A tiny monoid homomorphism structure. -/
structure MonoidHom (M N : Type)
    (monM : TinyMonoid M) (monN : TinyMonoid N) where
  toFun : M -> N
  map_unit : toFun monM.unit = monN.unit
  map_op : forall x y : M,
    toFun (monM.op x y) = monN.op (toFun x) (toFun y)
