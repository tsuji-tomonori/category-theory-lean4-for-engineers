-- Source: chapters/appD_migration_proof_checklist.tex:330

def migrateUsers (xs : List UserV1) : List UserV2 :=
  xs.map migrateUser

theorem migrateUsers_length (xs : List UserV1) :
    (migrateUsers xs).length = xs.length := by
  unfold migrateUsers
  simp
