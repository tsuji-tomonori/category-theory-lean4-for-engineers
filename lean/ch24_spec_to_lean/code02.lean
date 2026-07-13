-- 出典: chapters/ch24_spec_to_lean.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter24

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
