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

/-- A tiny response status used in the API wrapper example. -/
inductive Status where
  | ok
  | empty
  deriving Repr, DecidableEq

/-- Old API wrapper: at most one payload. -/
structure OldResponse (A : Type) where
  traceId : Nat
  payload : Option A
  deriving Repr

/-- New API wrapper: zero or more payload items plus status. -/
structure NewResponse (A : Type) where
  traceId : Nat
  status : Status
  items : List A
  deriving Repr

/-- Status depends only on whether the payload exists, not on its value. -/
def statusOf {A : Type} : Option A -> Status
  | none => Status.empty
  | some _ => Status.ok

/-- Map business logic inside the old wrapper. -/
def oldMap {A B : Type} (f : A -> B)
    (r : OldResponse A) : OldResponse B :=
  { traceId := r.traceId,
    payload := optionMap f r.payload }

/-- Map business logic inside the new wrapper. -/
def newMap {A B : Type} (f : A -> B)
    (r : NewResponse A) : NewResponse B :=
  { traceId := r.traceId,
    status := r.status,
    items := List.map f r.items }

/-- Adapter from the old wrapper to the new wrapper. -/
def adapt {A : Type} (r : OldResponse A) : NewResponse A :=
  { traceId := r.traceId,
    status := statusOf r.payload,
    items := optionToList r.payload }

#eval adapt ({ traceId := 7, payload := some 42 } : OldResponse Nat)

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
