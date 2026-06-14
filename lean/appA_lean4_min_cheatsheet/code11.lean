-- Source: chapters/appA_lean4_min_cheatsheet.tex:324

theorem map_length_inc (xs : List Nat) :
    (List.map inc xs).length = xs.length := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]
