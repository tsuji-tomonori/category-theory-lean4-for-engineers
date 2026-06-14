-- Source: chapters/ch04_invariants.tex:373

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
