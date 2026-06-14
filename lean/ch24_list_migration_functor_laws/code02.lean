-- Source: chapters/ch24_list_migration_functor_laws.tex:179

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v
  rfl

theorem migrateAll_length (xs : List UserV1) :
    (migrateAll xs).length = xs.length := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateAll, ih]
