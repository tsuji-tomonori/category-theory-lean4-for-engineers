-- Source: chapters/ch19_account_spec_proof.tex:162

theorem deposit_balance (a : Account) (amount : Amount) :
    (deposit a amount).balance = a.balance + amount := by
  rfl

theorem deposit_preserves_nonnegative (a : Account) (amount : Amount) :
    NonNegative (deposit a amount) := by
  exact Nat.zero_le (deposit a amount).balance
