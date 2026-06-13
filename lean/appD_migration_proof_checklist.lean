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

opaque Old : Type
opaque New : Type
opaque migrate : Old -> New
opaque rollback : New -> Old
opaque observeOld : Old -> Nat
opaque observeNew : New -> Nat
opaque WellFormedOld : Old -> Prop
opaque WellFormedNew : New -> Prop
opaque normalizeOld : Old -> Nat
opaque normalizeNew : New -> Nat
opaque abstract : Old -> Nat
opaque SafePublic : Nat -> Prop

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

theorem migrate_rollback_on_wellformed
    (y : New) (h : WellFormedNew y) :
    migrate (rollback y) = y := by
  sorry

theorem migrate_preserves_wellformed
    (x : Old) (h : WellFormedOld x) :
    WellFormedNew (migrate x) := by
  sorry

theorem normalized_observation_preserved (x : Old) :
    normalizeNew (migrate x) = normalizeOld x := by
  sorry

theorem abstraction_is_safe (x : Old) :
    SafePublic (abstract x) := by
  sorry
