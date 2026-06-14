-- Source: chapters/ch19_account_spec_proof.tex:189

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
