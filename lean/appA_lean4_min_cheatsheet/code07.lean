-- Source: chapters/appA_lean4_min_cheatsheet.tex:222

theorem append_nil_right (xs : List Nat) :
    xs ++ [] = xs := by
  simp

theorem map_nil_inc :
    List.map inc [] = [] := by
  simp
