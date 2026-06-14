-- 出典: chapters/appD_migration_proof_checklist.tex:330
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

structure UserV1 where
  id : Nat
  name : String
deriving Repr

structure Profile where
  displayName : String
deriving Repr

structure UserV2 where
  id : Nat
  profile : Profile
deriving Repr

def migrateUser : UserV1 -> UserV2 :=
  fun u =>
    { id := u.id
      profile := { displayName := u.name } }

def rollbackUser : UserV2 -> UserV1 :=
  fun u =>
    { id := u.id
      name := u.profile.displayName }

def HasSameId (u1 : UserV1) (u2 : UserV2) : Prop :=
  u1.id = u2.id

theorem migrate_preserves_id (u : UserV1) :
    HasSameId u (migrateUser u) := by
  rfl

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

def migrateUsers (xs : List UserV1) : List UserV2 :=
  xs.map migrateUser

theorem migrateUsers_length (xs : List UserV1) :
    (migrateUsers xs).length = xs.length := by
  unfold migrateUsers
  simp
