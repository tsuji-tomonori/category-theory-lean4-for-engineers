-- Source: chapters/app_c_property_patterns.tex:279

structure Row where
  id : Nat
  value : Nat

def migrateRow (r : Row) : Row :=
  { id := r.id, value := r.value + 1 }

theorem migrateRow_preserves_id (r : Row) :
    (migrateRow r).id = r.id := by
  rfl

theorem migrateRows_preserves_ids (rs : List Row) :
    rs.map (fun r => (migrateRow r).id) =
    rs.map (fun r => r.id) := by
  induction rs with
  | nil => rfl
  | cons r rs ih =>
      simp [migrateRow, ih]
