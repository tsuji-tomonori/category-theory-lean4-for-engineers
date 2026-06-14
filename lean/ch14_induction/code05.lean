-- Source: chapters/ch14_induction.tex:268

theorem append_length {α : Type} :
    ∀ xs ys : List α, (xs ++ ys).length = xs.length + ys.length := by
  intro xs ys
  induction xs with
  | nil =>
      simp
  | cons x xs ih =>
      simp [ih, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm]
