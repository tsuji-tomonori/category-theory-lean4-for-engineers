-- Source: chapters/ch13_cases_patterns.tex:144

-- Sum は左 inl / 右 inr の二通りに分解できる。
def sumTag (x : Sum Nat Nat) : Nat :=
  match x with
  | Sum.inl _ => 0
  | Sum.inr _ => 1

theorem sumTag_is_left_or_right (x : Sum Nat Nat) :
    Or (Exists fun n => And (x = Sum.inl n)
                             (sumTag x = 0))
       (Exists fun n => And (x = Sum.inr n)
                             (sumTag x = 1)) := by
  cases x with
  | inl n =>
      exact Or.inl ⟨n, rfl, rfl⟩
  | inr n =>
      exact Or.inr ⟨n, rfl, rfl⟩
