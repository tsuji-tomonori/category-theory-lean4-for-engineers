-- Source: chapters/appA_lean4_min_cheatsheet.tex:246

theorem rewrite_price
    (base fee total : Nat)
    (h : base + fee = total) :
    (base + fee) + 0 = total := by
  rw [h]
  simp
