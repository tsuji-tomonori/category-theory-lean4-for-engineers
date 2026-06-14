-- Source: chapters/ch02_props_specs.tex:62

/-
Chapter 2: Propositions, proofs, and specifications.
The examples in this file are intentionally small and use Lean 4's core features.
-/

namespace Ch02PropsSpecs

-- Bool is a value computed by a program.
def hasDiscount (member : Bool) : Bool :=
  member

#eval hasDiscount true
#eval hasDiscount false
