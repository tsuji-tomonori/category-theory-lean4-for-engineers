-- Source: chapters/app_c_property_patterns.tex:363

structure SmallV1 where
  id : Nat

structure SmallV2 where
  id : Nat

def toSmallV2 (x : SmallV1) : SmallV2 :=
  { id := x.id }

def toSmallV1 (x : SmallV2) : SmallV1 :=
  { id := x.id }

theorem map_roundtrip (xs : List SmallV1) :
    (xs.map toSmallV2).map toSmallV1 = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      simp [toSmallV2, toSmallV1, ih]
