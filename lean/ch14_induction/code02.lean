-- Source: chapters/ch14_induction.tex:164

def idsV1 (xs : List UserV1) : List Nat :=
  xs.map (fun u => u.id)

def idsV2 (xs : List UserV2) : List Nat :=
  xs.map (fun u => u.id)

theorem migrateUser_preserves_id (u : UserV1) :
    (migrateUser u).id = u.id := by
  rfl

theorem map_preserves_length {α β : Type} (f : α → β) :
    ∀ xs : List α, (xs.map f).length = xs.length := by
  intro xs
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]
