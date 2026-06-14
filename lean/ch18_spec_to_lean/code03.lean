-- Source: chapters/ch18_spec_to_lean.tex:241

-- 事前条件が成り立たなければ、withdraw は失敗する。
theorem withdraw_failure_when_not_allowed
    (a : Account) (amount : Nat)
    (h : Not (CanWithdraw a amount)) :
    withdraw a amount = none := by
  have hnot : ¬ amount <= a.balance := by
    simpa [CanWithdraw] using h
  simp [withdraw, hnot]

-- amount が 0 なら、どの口座でも出金後に同じ口座が返る。
theorem withdraw_zero (a : Account) :
    withdraw a 0 = some a := by
  cases a
  simp [withdraw]
