-- Source: chapters/appD_migration_proof_checklist.tex:291

theorem rollback_after_migrate (u : UserV1) :
    rollbackUser (migrateUser u) = u := by
  cases u
  rfl

theorem migrate_after_rollback (u : UserV2) :
    migrateUser (rollbackUser u) = u := by
  cases u with
  | mk id profile =>
    cases profile
    rfl
