-- Source: chapters/app_c_property_patterns.tex:413

def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

theorem optionToList_natural {A B : Type}
    (f : A -> B) (x : Option A) :
    optionToList (Option.map f x) =
    List.map f (optionToList x) := by
  cases x <;> rfl
