-- Source: chapters/ch09_natural_transformation.tex:170

/-
Chapter 09: Natural transformations as consistent adapters.
This file contains the Lean 4 snippets used in the chapter.
It intentionally avoids Mathlib CategoryTheory APIs.
-/

namespace Chapter09

/-- A small local version of Option.map, kept explicit for the chapter. -/
def optionMap {A B : Type} (f : A -> B) : Option A -> Option B
  | none => none
  | some a => some (f a)

/-- Adapter from an optional value to a list with zero or one element. -/
def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

#eval optionToList (some 10)
#eval optionToList (none : Option Nat)

/-- Naturality of the Option-to-List adapter. -/
theorem optionToList_naturality {A B : Type}
    (f : A -> B) (x : Option A) :
    optionToList (optionMap f x) =
      List.map f (optionToList x) := by
  cases x <;> rfl
