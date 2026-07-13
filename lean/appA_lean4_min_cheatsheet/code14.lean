-- 出典: chapters/appA_lean4_min_cheatsheet.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def serviceFee : Nat := 300

def addFee (price : Nat) : Nat :=
  price + serviceFee

def inc (n : Nat) : Nat :=
  n + 1

def double (n : Nat) : Nat :=
  n * 2

def pipeline (n : Nat) : Nat :=
  double (inc n)

#eval addFee 1000
#eval pipeline 10

structure UserV1 where
  id : Nat
  name : String

structure UserV2 where
  userId : Nat
  displayName : String

def migrateUser (u : UserV1) : UserV2 :=
  { userId := u.id, displayName := u.name }

def rollbackUser (u : UserV2) : UserV1 :=
  { id := u.userId, name := u.displayName }

def sameIdAfterMigrate (u : UserV1) : Nat :=
  (migrateUser u).userId

inductive Result (A : Type) where
  | ok : A -> Result A
  | err : String -> Result A

def validatePositive (n : Nat) : Result Nat :=
  if n = 0 then
    Result.err "zero is not positive"
  else
    Result.ok n

example : inc 0 = 1 := by
  rfl

theorem inc_eq_add_one (n : Nat) :
    inc n = n + 1 := by
  rfl

theorem rollback_migrate_user (u : UserV1) :
    rollbackUser (migrateUser u) = u := by
  rfl

theorem pipeline_ten :
    pipeline 10 = 22 := by
  rfl

theorem append_nil_right (xs : List Nat) :
    xs ++ [] = xs := by
  simp

theorem map_nil_inc :
    List.map inc [] = [] := by
  simp

theorem rewrite_price
    (base fee total : Nat)
    (h : base + fee = total) :
    (base + fee) + 0 = total := by
  rw [h]
  simp

theorem add_assoc_calc (a b c : Nat) :
    (a + b) + c = a + (b + c) := by
  calc
    (a + b) + c = a + (b + c) := by
      rw [Nat.add_assoc]

def isSomeNat (x : Option Nat) : Bool :=
  match x with
  | none => false
  | some _ => true

theorem isSomeNat_cases (x : Option Nat) :
    isSomeNat x = true \/ isSomeNat x = false := by
  cases x with
  | none =>
      exact Or.inr rfl
  | some n =>
      exact Or.inl rfl

theorem map_length_inc (xs : List Nat) :
    (List.map inc xs).length = xs.length := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

theorem pair_spec (n : Nat) :
    n = n /\ inc n = n + 1 := by
  constructor
  · exact rfl
  · exact rfl

theorem use_existing_evidence
    (P : Prop)
    (hp : P) : P := by
  exact hp

theorem use_implication
    (P Q : Prop)
    (h : P -> Q)
    (hp : P) : Q := by
  apply h
  exact hp
