-- 出典: chapters/ch09_natural_transformation.tex:223
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter09

def optionMap {A B : Type} (f : A -> B) : Option A -> Option B
  | none => none
  | some a => some (f a)

def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

#eval optionToList (some 10)
#eval optionToList (none : Option Nat)

theorem optionToList_naturality {A B : Type}
    (f : A -> B) (x : Option A) :
    optionToList (optionMap f x) =
      List.map f (optionToList x) := by
  cases x <;> rfl

structure NatTransOptionList where
  app : {A : Type} -> Option A -> List A
  naturality :
    {A B : Type} -> (f : A -> B) -> (x : Option A) ->
      app (optionMap f x) = List.map f (app x)

def optionToListNT : NatTransOptionList where
  app := fun x => optionToList x
  naturality := by
    intro A B f x
    cases x <;> rfl
