-- Source: chapters/ch19_account_spec_proof.tex:235

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
