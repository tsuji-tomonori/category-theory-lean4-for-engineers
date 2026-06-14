-- 出典: chapters/appD_migration_proof_checklist.tex:477
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

def renameV1 (u : UserV1) (s : String) : UserV1 :=
  { u with name := s }

def renameV2 (u : UserV2) (s : String) : UserV2 :=
  { u with profile := { displayName := s } }

theorem migrate_rename_commutes (u : UserV1) (s : String) :
    migrateUser (renameV1 u s) = renameV2 (migrateUser u) s := by
  cases u
  rfl

axiom Old : Type
axiom New : Type
axiom migrate : Old -> New
axiom rollback : New -> Old
axiom observeOld : Old -> Nat
axiom observeNew : New -> Nat
axiom WellFormedOld : Old -> Prop
axiom WellFormedNew : New -> Prop
axiom normalizeOld : Old -> Nat
axiom normalizeNew : New -> Nat
axiom abstract : Old -> Nat
axiom SafePublic : Nat -> Prop

theorem rollback_migrate_id (x : Old) :
    rollback (migrate x) = x := by
  sorry

theorem migrate_rollback_id (y : New) :
    migrate (rollback y) = y := by
  sorry

theorem old_roundtrip (x : Old) :
    rollback (migrate x) = x := by
  sorry

theorem old_observation_preserved (x : Old) :
    observeNew (migrate x) = observeOld x := by
  sorry
