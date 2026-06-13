/-
Chapter 19: Account operation specification proofs.
This file contains the Lean 4 snippets used by chapters/ch19_account_spec_proof.tex.
-/

namespace Chapter19

abbrev AccountId := Nat
abbrev Balance := Nat
abbrev Amount := Nat

structure Account where
  id : AccountId
  balance : Balance
deriving Repr, DecidableEq

def NonNegative (a : Account) : Prop :=
  0 <= a.balance

theorem account_nonnegative (a : Account) : NonNegative a := by
  exact Nat.zero_le a.balance

def deposit (a : Account) (amount : Amount) : Account :=
  { a with balance := a.balance + amount }

def withdraw? (a : Account) (amount : Amount) : Option Account :=
  if amount <= a.balance then
    some { a with balance := a.balance - amount }
  else
    none

def totalBalance (a b : Account) : Balance :=
  a.balance + b.balance

def transfer? (from to : Account) (amount : Amount) : Option (Account × Account) :=
  match withdraw? from amount with
  | none => none
  | some from' => some (from', deposit to amount)

theorem deposit_balance (a : Account) (amount : Amount) :
    (deposit a amount).balance = a.balance + amount := by
  rfl

theorem deposit_preserves_nonnegative (a : Account) (amount : Amount) :
    NonNegative (deposit a amount) := by
  exact Nat.zero_le (deposit a amount).balance

def CanWithdraw (a : Account) (amount : Amount) : Prop :=
  amount <= a.balance

theorem withdraw_success (a : Account) (amount : Amount)
    (h : CanWithdraw a amount) :
    withdraw? a amount = some { a with balance := a.balance - amount } := by
  have h' : amount <= a.balance := h
  simp [withdraw?, h']

theorem withdraw_failure (a : Account) (amount : Amount)
    (h : ¬ CanWithdraw a amount) :
    withdraw? a amount = none := by
  have h' : ¬ amount <= a.balance := by
    intro hp
    exact h hp
  simp [withdraw?, h']

theorem transfer_success (from to : Account) (amount : Amount)
    (h : CanWithdraw from amount) :
    transfer? from to amount =
      some ({ from with balance := from.balance - amount },
            { to with balance := to.balance + amount }) := by
  have h' : amount <= from.balance := h
  simp [transfer?, withdraw?, deposit, h']

theorem transfer_failure (from to : Account) (amount : Amount)
    (h : ¬ CanWithdraw from amount) :
    transfer? from to amount = none := by
  have h' : ¬ amount <= from.balance := by
    intro hp
    exact h hp
  simp [transfer?, withdraw?, h']

theorem transfer_success_preserves_total
    (from to : Account) (amount : Amount)
    (h : CanWithdraw from amount) :
    totalBalance { from with balance := from.balance - amount }
      { to with balance := to.balance + amount } =
    totalBalance from to := by
  have h' : amount <= from.balance := h
  dsimp [totalBalance]
  calc
    (from.balance - amount) + (to.balance + amount)
        = (from.balance - amount) + (amount + to.balance) := by
            rw [Nat.add_comm to.balance amount]
    _ = ((from.balance - amount) + amount) + to.balance := by
            rw [← Nat.add_assoc]
    _ = from.balance + to.balance := by
            rw [Nat.sub_add_cancel h']

theorem transfer_result_preserves_total
    (from to from' to' : Account) (amount : Amount)
    (hTransfer : transfer? from to amount = some (from', to')) :
    totalBalance from' to' = totalBalance from to := by
  unfold transfer? at hTransfer
  by_cases h : amount <= from.balance
  · simp [withdraw?, h, deposit] at hTransfer
    cases hTransfer
    exact transfer_success_preserves_total from to amount h
  · simp [withdraw?, h] at hTransfer

def alice : Account := { id := 1, balance := 100 }
def bob : Account := { id := 2, balance := 40 }

#eval deposit alice 20
#eval withdraw? alice 30
#eval withdraw? alice 130
#eval transfer? alice bob 30

end Chapter19
