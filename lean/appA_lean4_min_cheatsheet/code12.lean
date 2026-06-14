-- Source: chapters/appA_lean4_min_cheatsheet.tex:354

theorem pair_spec (n : Nat) :
    n = n /\ inc n = n + 1 := by
  constructor
  · exact rfl
  · exact rfl
