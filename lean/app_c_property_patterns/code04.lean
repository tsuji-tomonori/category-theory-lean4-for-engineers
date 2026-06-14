-- Source: chapters/app_c_property_patterns.tex:230

structure ItemV1 where
  id : Nat
  payload : Nat

structure ItemV2 where
  id : Nat
  body : Nat

def migrateItem (x : ItemV1) : ItemV2 :=
  { id := x.id, body := x.payload }

theorem migrateItems_preserves_length (xs : List ItemV1) :
    (xs.map migrateItem).length = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      simp [List.map, ih]
