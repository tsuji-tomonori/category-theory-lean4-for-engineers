-- 出典: chapters/app_c_property_patterns.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

structure UserV1 where
  id : Nat
  name : String

deriving Repr

structure UserV2 where
  id : Nat
  profileName : String

deriving Repr

def migrate (u : UserV1) : UserV2 :=
  { id := u.id, profileName := u.name }

def rollback (u : UserV2) : UserV1 :=
  { id := u.id, name := u.profileName }

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

inductive Status where
  | draft
  | active
  | archived
  | deleted

def normalizeStatus : Status -> Status
  | Status.deleted => Status.archived
  | s => s

theorem normalizeStatus_idempotent (s : Status) :
    normalizeStatus (normalizeStatus s) = normalizeStatus s := by
  cases s <;> rfl

def SpecLe {A : Type} (p q : A -> Prop) : Prop :=
  forall x, p x -> q x

theorem SpecLe_refl {A : Type} (p : A -> Prop) :
    SpecLe p p := by
  intro x hx
  exact hx

theorem SpecLe_trans {A : Type} (p q r : A -> Prop) :
    SpecLe p q -> SpecLe q r -> SpecLe p r := by
  intro hpq hqr x hx
  exact hqr x (hpq x hx)

structure ItemV1 where
  id : Nat
  payload : Nat

structure ItemV2 where
  id : Nat
  body : Nat

def migrateItem (x : ItemV1) : ItemV2 :=
  { id := x.id, body := x.payload }

theorem migrateItems_preserves_length (xs : List ItemV1) :
    (xs.map migrateItem).length = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      simp [List.map, ih]
