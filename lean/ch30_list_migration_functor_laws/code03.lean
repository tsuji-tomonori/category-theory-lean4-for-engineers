-- 出典: chapters/ch24_list_migration_functor_laws.tex:234
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
      simp [migrateAll, ih]

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
