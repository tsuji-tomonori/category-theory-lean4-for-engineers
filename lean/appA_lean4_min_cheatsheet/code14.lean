-- Source: chapters/appA_lean4_min_cheatsheet.tex:395

theorem use_implication
    (P Q : Prop)
    (h : P -> Q)
    (hp : P) : Q := by
  apply h
  exact hp
