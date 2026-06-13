/-
Chapter 04: Data structures and invariants

This file contains the Lean snippets used in chapters/ch04_invariants.tex.
It is intentionally small and uses only Lean's core/prelude-level features.
-/

namespace Chapter04

structure User where
  id : Nat
  name : String
  deriving Repr, DecidableEq

structure Account where
  ownerId : Nat
  balance : Nat
  deriving Repr, DecidableEq

-- A sample value used by #eval examples.
def sampleAccount : Account :=
  { ownerId := 1, balance := 100 }

#eval sampleAccount.balance

-- Account validity. In this toy model, ownerId = 0 is treated as invalid.
def AccountValid (a : Account) : Prop :=
  0 < a.ownerId

-- Deposit changes only the balance.
def deposit (a : Account) (amount : Nat) : Account :=
  { a with balance := a.balance + amount }

-- Deposit preserves account validity because it does not change ownerId.
theorem deposit_preserves_valid
    (a : Account) (amount : Nat)
    (h : AccountValid a) :
    AccountValid (deposit a amount) := by
  simpa [deposit, AccountValid] using h

-- The precondition for successful withdrawal.
def CanWithdraw (a : Account) (amount : Nat) : Prop :=
  amount <= a.balance

-- The postcondition after a successful withdrawal.
def WithdrawPost
    (oldAccount newAccount : Account)
    (amount : Nat) : Prop :=
  And (newAccount.ownerId = oldAccount.ownerId)
      (newAccount.balance + amount = oldAccount.balance)

-- Valid accounts as a subtype.
def ValidAccount : Type :=
  { a : Account // AccountValid a }

-- Extract a field from the value inside the subtype.
def validAccountBalance (a : ValidAccount) : Nat :=
  a.val.balance

-- Deposit on ValidAccount returns another ValidAccount.
def depositValid (a : ValidAccount) (amount : Nat) : ValidAccount :=
  Subtype.mk (deposit a.val amount)
    (deposit_preserves_valid a.val amount a.property)

-- A withdrawal operation that can fail.
def withdrawOpt (a : Account) (amount : Nat) : Option Account :=
  if h : amount <= a.balance then
    some { a with balance := a.balance - amount }
  else
    none

#eval withdrawOpt sampleAccount 40
#eval withdrawOpt sampleAccount 150

-- A withdrawal operation that requires the precondition as an argument.
def withdrawChecked
    (a : Account) (amount : Nat)
    (_h : CanWithdraw a amount) : Account :=
  { a with balance := a.balance - amount }

-- Successful withdrawal satisfies the postcondition.
theorem withdrawChecked_post
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    WithdrawPost a (withdrawChecked a amount h) amount := by
  unfold withdrawChecked WithdrawPost CanWithdraw at *
  constructor
  · rfl
  · exact Nat.sub_add_cancel h

-- If the precondition holds, withdrawOpt returns some updated account.
theorem withdrawOpt_success
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    withdrawOpt a amount =
      some { a with balance := a.balance - amount } := by
  unfold withdrawOpt CanWithdraw at *
  simp [h]

-- If the precondition does not hold, withdrawOpt returns none.
theorem withdrawOpt_failure
    (a : Account) (amount : Nat)
    (h : Not (CanWithdraw a amount)) :
    withdrawOpt a amount = none := by
  unfold withdrawOpt CanWithdraw at *
  simp [h]

end Chapter04
