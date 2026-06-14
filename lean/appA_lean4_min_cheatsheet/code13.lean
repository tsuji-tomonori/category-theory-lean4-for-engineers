-- Source: chapters/appA_lean4_min_cheatsheet.tex:375

theorem use_existing_evidence
    (P : Prop)
    (hp : P) : P := by
  exact hp
