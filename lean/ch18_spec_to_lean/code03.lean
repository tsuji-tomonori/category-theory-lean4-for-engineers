-- 出典: chapters/ch18_spec_to_lean.tex:241
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter18

structure Account where
  balance : Nat
  deriving Repr, DecidableEq

def CanWithdraw (a : Account) (amount : Nat) : Prop :=
  amount <= a.balance

def withdraw (a : Account) (amount : Nat) : Option Account :=
  if amount <= a.balance then
    some { balance := a.balance - amount }
  else
    none

def PostSuccess
    (before : Account) (amount : Nat) (after : Account) : Prop :=
  after.balance = before.balance - amount

theorem withdraw_success_when_allowed
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    withdraw a amount = some { balance := a.balance - amount } := by
  have hle : amount <= a.balance := by
    simpa [CanWithdraw] using h
  simp [withdraw, hle]

theorem withdraw_success_post
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    Exists (fun b =>
      withdraw a amount = some b /\ PostSuccess a amount b) := by
  exact Exists.intro { balance := a.balance - amount }
    (And.intro (withdraw_success_when_allowed a amount h) rfl)

theorem withdraw_failure_when_not_allowed
    (a : Account) (amount : Nat)
    (h : Not (CanWithdraw a amount)) :
    withdraw a amount = none := by
  have hnot : ¬ amount <= a.balance := by
    simpa [CanWithdraw] using h
  simp [withdraw, hnot]

theorem withdraw_zero (a : Account) :
    withdraw a 0 = some a := by
  cases a
  simp [withdraw]
