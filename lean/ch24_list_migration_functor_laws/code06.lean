-- Source: chapters/ch24_list_migration_functor_laws.tex:377

def idsV1 (xs : List UserV1) : List Nat :=
  xs.map UserV1.id

def idsV2 (xs : List UserV2) : List Nat :=
  xs.map UserV2.userId

theorem migrateAll_preservesIds (xs : List UserV1) :
    idsV2 (migrateAll xs) = idsV1 xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [idsV1, idsV2, migrateAll, migrate, ih]
