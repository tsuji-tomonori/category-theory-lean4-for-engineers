-- Source: chapters/ch24_list_migration_functor_laws.tex:340

theorem rollbackAll_migrateAll (xs : List UserV1) :
    rollbackAll (migrateAll xs) = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      unfold rollbackAll migrateAll at ih ⊢
      simp [rollback_migrate, ih]

theorem migrateAll_rollbackAll (ys : List UserV2) :
    migrateAll (rollbackAll ys) = ys := by
  induction ys with
  | nil =>
      rfl
  | cons y ys ih =>
      unfold rollbackAll migrateAll at ih ⊢
      simp [migrate_rollback, ih]
