-- Source: chapters/ch04_invariants.tex:423

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
