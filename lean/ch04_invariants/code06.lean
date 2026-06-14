-- 出典: chapters/ch04_invariants.tex:373
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter04

structure User where
  id : Nat
  name : String
  deriving Repr, DecidableEq

structure Account where
  ownerId : Nat
  balance : Nat
  deriving Repr, DecidableEq

def sampleAccount : Account :=
  { ownerId := 1, balance := 100 }

#eval sampleAccount.balance

def AccountValid (a : Account) : Prop :=
  0 < a.ownerId

def deposit (a : Account) (amount : Nat) : Account :=
  { a with balance := a.balance + amount }

theorem deposit_preserves_valid
    (a : Account) (amount : Nat)
    (h : AccountValid a) :
    AccountValid (deposit a amount) := by
  simpa [deposit, AccountValid] using h

def CanWithdraw (a : Account) (amount : Nat) : Prop :=
  amount <= a.balance

def WithdrawPost
    (oldAccount newAccount : Account)
    (amount : Nat) : Prop :=
  And (newAccount.ownerId = oldAccount.ownerId)
      (newAccount.balance + amount = oldAccount.balance)

def ValidAccount : Type :=
  { a : Account // AccountValid a }

def validAccountBalance (a : ValidAccount) : Nat :=
  a.val.balance

def depositValid (a : ValidAccount) (amount : Nat) : ValidAccount :=
  Subtype.mk (deposit a.val amount)
    (deposit_preserves_valid a.val amount a.property)

def withdrawOpt (a : Account) (amount : Nat) : Option Account :=
  if h : amount <= a.balance then
    some { a with balance := a.balance - amount }
  else
    none

#eval withdrawOpt sampleAccount 40
#eval withdrawOpt sampleAccount 150

def withdrawChecked
    (a : Account) (amount : Nat)
    (_h : CanWithdraw a amount) : Account :=
  { a with balance := a.balance - amount }

theorem withdrawChecked_post
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    WithdrawPost a (withdrawChecked a amount h) amount := by
  unfold withdrawChecked WithdrawPost CanWithdraw at *
  constructor
  · rfl
  · exact Nat.sub_add_cancel h
