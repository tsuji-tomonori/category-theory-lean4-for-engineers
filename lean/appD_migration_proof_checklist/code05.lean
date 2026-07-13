-- 出典: chapters/appD_migration_proof_checklist.tex（対応する本文コードブロック）
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

def WellFormedV1 (u : UserV1) : Prop :=
  u.name ≠ ""

def WellFormedV2 (u : UserV2) : Prop :=
  u.profile.displayName ≠ ""

theorem migrateUser_preserves_wellformed (u : UserV1)
    (h : WellFormedV1 u) :
    WellFormedV2 (migrateUser u) := by
  unfold WellFormedV1 at h
  unfold WellFormedV2 migrateUser
  exact h

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
