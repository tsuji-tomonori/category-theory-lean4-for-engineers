-- Source: chapters/ch09_natural_transformation.tex:389

/-- The API adapter commutes with business logic. -/
theorem adapt_naturality {A B : Type}
    (f : A -> B) (r : OldResponse A) :
    adapt (oldMap f r) = newMap f (adapt r) := by
  cases r with
  | mk trace payload =>
    cases payload <;> rfl

/-- The same naturality property, stated as equality of wrapper-level functions. -/
theorem adapt_naturality_as_function_equality {A B : Type}
    (f : A -> B) :
    (fun r : OldResponse A => adapt (oldMap f r)) =
      (fun r : OldResponse A => newMap f (adapt r)) := by
  funext r
  exact adapt_naturality f r


end Chapter09
