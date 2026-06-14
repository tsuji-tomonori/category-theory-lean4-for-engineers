-- Source: chapters/ch09_natural_transformation.tex:223

/-- A learning-only structure for the natural transformation Option => List. -/
structure NatTransOptionList where
  app : {A : Type} -> Option A -> List A
  naturality :
    {A B : Type} -> (f : A -> B) -> (x : Option A) ->
      app (optionMap f x) = List.map f (app x)

/-- The Option-to-List adapter bundled with its naturality proof. -/
def optionToListNT : NatTransOptionList where
  app := fun x => optionToList x
  naturality := by
    intro A B f x
    cases x <;> rfl
