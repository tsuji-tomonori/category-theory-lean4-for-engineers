-- Source: chapters/ch18_spec_to_lean.tex:310

-- 出金に失敗した場合は、元の口座をそのまま返す。
def withdrawOrKeep (a : Account) (amount : Nat) : Account :=
  match withdraw a amount with
  | some b => b
  | none => a

-- 失敗条件では、状態が変わらない。
theorem withdrawOrKeep_failure_keeps
    (a : Account) (amount : Nat)
    (h : Not (CanWithdraw a amount)) :
    withdrawOrKeep a amount = a := by
  have hnot : ¬ amount <= a.balance := by
    simpa [CanWithdraw] using h
  simp [withdrawOrKeep, withdraw, hnot]

-- 成功条件では、残高が amount だけ減る。
theorem withdrawOrKeep_success_balance
    (a : Account) (amount : Nat)
    (h : CanWithdraw a amount) :
    (withdrawOrKeep a amount).balance = a.balance - amount := by
  have hle : amount <= a.balance := by
    simpa [CanWithdraw] using h
  simp [withdrawOrKeep, withdraw, hle]


end Chapter18
