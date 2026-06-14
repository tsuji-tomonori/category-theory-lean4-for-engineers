-- Source: chapters/appD_migration_proof_checklist.tex:370

def renameV1 (u : UserV1) (s : String) : UserV1 :=
  { u with name := s }

def renameV2 (u : UserV2) (s : String) : UserV2 :=
  { u with profile := { displayName := s } }

theorem migrate_rename_commutes (u : UserV1) (s : String) :
    migrateUser (renameV1 u s) = renameV2 (migrateUser u) s := by
  cases u
  rfl
