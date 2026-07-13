-- 出典: chapters/ch30_list_migration_functor_laws.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

structure UserV1 where
  id : Nat
  name : String
  active : Bool
deriving Repr, DecidableEq

structure UserV2 where
  userId : Nat
  profileName : String
  enabled : Bool
deriving Repr, DecidableEq

def migrate (u : UserV1) : UserV2 :=
  { userId := u.id,
    profileName := u.name,
    enabled := u.active }

def rollback (v : UserV2) : UserV1 :=
  { id := v.userId,
    name := v.profileName,
    active := v.enabled }

def migrateAll (xs : List UserV1) : List UserV2 :=
  xs.map migrate

def rollbackAll (xs : List UserV2) : List UserV1 :=
  xs.map rollback

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v
  rfl

theorem migrateAll_length (xs : List UserV1) :
    (migrateAll xs).length = xs.length := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateAll]

theorem list_map_id {A : Type} (xs : List A) :
    xs.map (fun x => x) = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [ih]

theorem list_map_comp {A B C : Type}
    (f : A -> B) (g : B -> C) (xs : List A) :
    xs.map (fun x => g (f x)) = (xs.map f).map g := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [ih]

structure UserV3 where
  accountId : Nat
  displayName : String
  canLogin : Bool
deriving Repr, DecidableEq

def normalize (v : UserV2) : UserV3 :=
  { accountId := v.userId,
    displayName := v.profileName,
    canLogin := v.enabled }

def migrateThenNormalize (u : UserV1) : UserV3 :=
  normalize (migrate u)

def migrateAllThenNormalize (xs : List UserV1) : List UserV3 :=
  xs.map migrateThenNormalize

def normalizeAfterMigrateAll (xs : List UserV1) : List UserV3 :=
  (migrateAll xs).map normalize

theorem migrateAll_composition (xs : List UserV1) :
    migrateAllThenNormalize xs = normalizeAfterMigrateAll xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateAllThenNormalize, normalizeAfterMigrateAll,
        migrateThenNormalize, migrateAll]

theorem rollbackAll_migrateAll (xs : List UserV1) :
    rollbackAll (migrateAll xs) = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      unfold rollbackAll migrateAll at ih ⊢
      simp [rollback_migrate, ih]

theorem migrateAll_rollbackAll (ys : List UserV2) :
    migrateAll (rollbackAll ys) = ys := by
  induction ys with
  | nil =>
      rfl
  | cons y ys ih =>
      unfold rollbackAll migrateAll at ih ⊢
      simp [migrate_rollback, ih]

def idsV1 (xs : List UserV1) : List Nat :=
  xs.map UserV1.id

def idsV2 (xs : List UserV2) : List Nat :=
  xs.map UserV2.userId

theorem migrateAll_preservesIds (xs : List UserV1) :
    idsV2 (migrateAll xs) = idsV1 xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [idsV1, idsV2, migrateAll, migrate]
