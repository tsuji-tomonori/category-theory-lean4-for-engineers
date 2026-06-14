-- Source: chapters/ch04_invariants.tex:213

-- The precondition for successful withdrawal.
def CanWithdraw (a : Account) (amount : Nat) : Prop :=
  amount <= a.balance

-- The postcondition after a successful withdrawal.
def WithdrawPost
    (oldAccount newAccount : Account)
    (amount : Nat) : Prop :=
  And (newAccount.ownerId = oldAccount.ownerId)
      (newAccount.balance + amount = oldAccount.balance)
