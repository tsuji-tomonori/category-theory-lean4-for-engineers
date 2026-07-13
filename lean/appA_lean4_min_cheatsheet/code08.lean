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
