-- 出典: chapters/ch25_account_spec_proof.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter25

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

def transfer? (src to : Account) (amount : Amount) : Option (Account × Account) :=
  match withdraw? src amount with
  | none => none
  | some src' => some (src', deposit to amount)

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

theorem transfer_success (src to : Account) (amount : Amount)
    (h : CanWithdraw src amount) :
    transfer? src to amount =
      some ({ src with balance := src.balance - amount },
            { to with balance := to.balance + amount }) := by
  have h' : amount <= src.balance := h
  simp [transfer?, withdraw?, deposit, h']

theorem transfer_failure (src to : Account) (amount : Amount)
    (h : ¬ CanWithdraw src amount) :
    transfer? src to amount = none := by
  have h' : ¬ amount <= src.balance := by
    intro hp
    exact h hp
  simp [transfer?, withdraw?, h']

theorem transfer_success_preserves_total
    (src to : Account) (amount : Amount)
    (h : CanWithdraw src amount) :
    totalBalance { src with balance := src.balance - amount }
      { to with balance := to.balance + amount } =
    totalBalance src to := by
  have h' : amount <= src.balance := h
  dsimp [totalBalance]
  calc
    (src.balance - amount) + (to.balance + amount)
        = (src.balance - amount) + (amount + to.balance) := by
            rw [Nat.add_comm to.balance amount]
    _ = ((src.balance - amount) + amount) + to.balance := by
            rw [← Nat.add_assoc]
    _ = src.balance + to.balance := by
            rw [Nat.sub_add_cancel h']

theorem transfer_result_preserves_total
    (src to src' to' : Account) (amount : Amount)
    (hTransfer : transfer? src to amount = some (src', to')) :
    totalBalance src' to' = totalBalance src to := by
  unfold transfer? at hTransfer
  by_cases h : amount <= src.balance
  · simp [withdraw?, h, deposit] at hTransfer
    rw [← hTransfer.left, ← hTransfer.right]
    exact transfer_success_preserves_total src to amount h
  · simp [withdraw?, h] at hTransfer
