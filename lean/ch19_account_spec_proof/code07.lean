-- Source: chapters/ch19_account_spec_proof.tex:307

theorem transfer_result_preserves_total
    (src to src' to' : Account) (amount : Amount)
    (hTransfer : transfer? src to amount = some (src', to')) :
    totalBalance src' to' = totalBalance src to := by
  unfold transfer? at hTransfer
  by_cases h : amount <= src.balance
  · simp [withdraw?, h, deposit] at hTransfer
    rw [← hTransfer.left, ← hTransfer.right]
    exact transfer_success_preserves_total src to amount h
  · simp [withdraw?, h] at hTransfer
