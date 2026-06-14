-- Source: chapters/appD_migration_proof_checklist.tex:252

def HasSameId (u1 : UserV1) (u2 : UserV2) : Prop :=
  u1.id = u2.id

theorem migrate_preserves_id (u : UserV1) :
    HasSameId u (migrateUser u) := by
  rfl
