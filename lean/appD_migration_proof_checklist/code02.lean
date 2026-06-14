-- Source: chapters/appD_migration_proof_checklist.tex:158

def migrateUser : UserV1 -> UserV2 :=
  fun u =>
    { id := u.id
      profile := { displayName := u.name } }
