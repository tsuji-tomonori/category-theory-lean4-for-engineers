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

def addQuota (extra quota : Nat) : Nat :=
  quota + extra

theorem addQuota_monotone (extra x y : Nat) (h : x <= y) :
    addQuota extra x <= addQuota extra y := by
  unfold addQuota
  exact Nat.add_le_add_right h extra

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

structure Row where
  id : Nat
  value : Nat

def migrateRow (r : Row) : Row :=
  { id := r.id, value := r.value + 1 }

theorem migrateRow_preserves_id (r : Row) :
    (migrateRow r).id = r.id := by
  rfl

theorem migrateRows_preserves_ids (rs : List Row) :
    rs.map (fun r => (migrateRow r).id) =
    rs.map (fun r => r.id) := by
  induction rs with
  | nil => rfl
  | cons r rs ih =>
      simp [migrateRow]

structure AccountPair where
  left : Nat
  right : Nat

def total (p : AccountPair) : Nat :=
  p.left + p.right

def swapAccounts (p : AccountPair) : AccountPair :=
  { left := p.right, right := p.left }

theorem swapAccounts_preserves_total (p : AccountPair) :
    total (swapAccounts p) = total p := by
  unfold total swapAccounts
  exact Nat.add_comm p.right p.left

structure SmallV1 where
  id : Nat

structure SmallV2 where
  id : Nat

def toSmallV2 (x : SmallV1) : SmallV2 :=
  { id := x.id }

def toSmallV1 (x : SmallV2) : SmallV1 :=
  { id := x.id }

theorem small_roundtrip (x : SmallV1) :
    toSmallV1 (toSmallV2 x) = x := by
  cases x
  rfl

theorem map_roundtrip (xs : List SmallV1) :
    (xs.map toSmallV2).map toSmallV1 = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
      simp [toSmallV2, toSmallV1, ih]

def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

theorem optionToList_natural {A B : Type}
    (f : A -> B) (x : Option A) :
    optionToList (Option.map f x) =
    List.map f (optionToList x) := by
  cases x <;> rfl

structure BoundedAccount where
  balance : Nat
  ceiling : Nat

def WithinLimit (a : BoundedAccount) : Prop :=
  a.balance <= a.ceiling

def withdraw (amount : Nat) (a : BoundedAccount) : BoundedAccount :=
  { balance := a.balance - amount, ceiling := a.ceiling }

theorem withdraw_preserves_limit
    (amount : Nat) (a : BoundedAccount) :
    WithinLimit a -> WithinLimit (withdraw amount a) := by
  intro h
  unfold WithinLimit withdraw
  exact Nat.le_trans (Nat.sub_le a.balance amount) h
