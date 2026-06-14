-- Source: chapters/appA_lean4_min_cheatsheet.tex:269

theorem add_assoc_calc (a b c : Nat) :
    (a + b) + c = a + (b + c) := by
  calc
    (a + b) + c = a + (b + c) := by
      rw [Nat.add_assoc]
