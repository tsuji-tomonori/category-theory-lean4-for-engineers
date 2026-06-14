-- Source: chapters/ch18_spec_to_lean.tex:165

-- 成功時の事後条件。
def PostSuccess
    (before : Account) (amount : Nat) (after : Account) : Prop :=
  after.balance = before.balance - amount

-- 事前条件があれば、withdraw は成功する。
theorem withdraw_success_when_allowed
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    withdraw a amount = some { balance := a.balance - amount } := by
  have hle : amount <= a.balance := by
    simpa [CanWithdraw] using h
  simp [withdraw, hle]

-- 成功時の戻り値は、PostSuccess を満たす。
theorem withdraw_success_post
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    Exists (fun b =>
      withdraw a amount = some b /\ PostSuccess a amount b) := by
  exact Exists.intro { balance := a.balance - amount }
    (And.intro (withdraw_success_when_allowed a amount h) rfl)
