-- Source: chapters/appD_migration_proof_checklist.tex:192

def rollbackUser : UserV2 -> UserV1 :=
  fun u =>
    { id := u.id
      name := u.profile.displayName }
