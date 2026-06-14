-- Source: chapters/ch30_team_operations.tex:90

/-
Chapter 30: Team operations for using Lean in development.
This file contains the Lean snippets used in the chapter.
-/

namespace Chapter30

/-- A small status model for specification items. -/
inductive SpecStatus where
  | draft
  | reviewed
  | proved

deriving Repr, DecidableEq

/-- A specification item tracked by the team. -/
structure SpecItem where
  id : Nat
  title : String
  status : SpecStatus

/-- Mark a specification item as proved. -/
def markProved (s : SpecItem) : SpecItem :=
  { s with status := SpecStatus.proved }

/-- The proposition that a specification item is proved. -/
def IsProved (s : SpecItem) : Prop :=
  s.status = SpecStatus.proved

/-- After `markProved`, the item is proved in this small model. -/
theorem markProved_isProved (s : SpecItem) :
    IsProved (markProved s) := by
  unfold IsProved markProved
  rfl
