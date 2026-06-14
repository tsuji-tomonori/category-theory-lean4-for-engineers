-- Source: chapters/ch14_induction.tex:233
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def idsV1 (xs : List UserV1) : List Nat :=
  xs.map (fun u => u.id)

def idsV2 (xs : List UserV2) : List Nat :=
  xs.map (fun u => u.id)

theorem migrateUsers_preserves_ids (xs : List UserV1) :
    idsV2 (migrateUsers xs) = idsV1 xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateUsers, idsV1, idsV2, migrateUser, ih]
