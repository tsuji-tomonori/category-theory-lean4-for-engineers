-- Source: chapters/ch19_account_spec_proof.tex:272

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
