/-
第18章 仕様書を Lean に移す方法
Lean 4 examples extracted from chapters/ch18_spec_to_lean.tex.

このファイルは、自然言語仕様から型・関数・述語・定理を切り出す
最小モデルを示す。Mathlib には依存しない。
-/

namespace Chapter18

-- 本章では、金額を Nat で単純化する。
-- 現実の通貨、小数、丸めは後で境界として明示する。
structure Account where
  balance : Nat
  deriving Repr, DecidableEq

-- 出金が成功するための事前条件。
def CanWithdraw (a : Account) (amount : Nat) : Prop :=
  amount <= a.balance

-- 成功すれば更新後の口座を返す。
-- 失敗すれば none を返す。
def withdraw (a : Account) (amount : Nat) : Option Account :=
  if amount <= a.balance then
    some { balance := a.balance - amount }
  else
    none

-- 成功時の事後条件。
def PostSuccess
    (before : Account) (amount : Nat) (after : Account) : Prop :=
  after.balance = before.balance - amount

-- 事前条件があれば、withdraw は成功する。
theorem withdraw_success_when_allowed
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    withdraw a amount = some { balance := a.balance - amount } := by
  simp [withdraw, CanWithdraw, h]

-- 成功時の戻り値は、PostSuccess を満たす。
theorem withdraw_success_post
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    Exists (fun b =>
      withdraw a amount = some b /\ PostSuccess a amount b) := by
  exact Exists.intro { balance := a.balance - amount }
    (And.intro (withdraw_success_when_allowed a amount h) rfl)

-- 事前条件が成り立たなければ、withdraw は失敗する。
theorem withdraw_failure_when_not_allowed
    (a : Account) (amount : Nat)
    (h : Not (CanWithdraw a amount)) :
    withdraw a amount = none := by
  simp [withdraw, CanWithdraw, h]

-- amount が 0 なら、どの口座でも出金後に同じ口座が返る。
theorem withdraw_zero (a : Account) :
    withdraw a 0 = some a := by
  cases a
  simp [withdraw]

-- 出金に失敗した場合は、元の口座をそのまま返す。
def withdrawOrKeep (a : Account) (amount : Nat) : Account :=
  match withdraw a amount with
  | some b => b
  | none => a

-- 失敗条件では、状態が変わらない。
theorem withdrawOrKeep_failure_keeps
    (a : Account) (amount : Nat)
    (h : Not (CanWithdraw a amount)) :
    withdrawOrKeep a amount = a := by
  simp [withdrawOrKeep, withdraw, CanWithdraw, h]

-- 成功条件では、残高が amount だけ減る。
theorem withdrawOrKeep_success_balance
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    (withdrawOrKeep a amount).balance = a.balance - amount := by
  simp [withdrawOrKeep, withdraw, CanWithdraw, h]

end Chapter18
