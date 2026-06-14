-- Source: chapters/ch04_invariants.tex:62

/-
Chapter 04: Data structures and invariants

This file contains the Lean snippets used in chapters/ch04_invariants.tex.
It is intentionally small and uses only Lean's core/prelude-level features.
-/

namespace Chapter04

structure User where
  id : Nat
  name : String
  deriving Repr, DecidableEq

structure Account where
  ownerId : Nat
  balance : Nat
  deriving Repr, DecidableEq

-- A sample value used by #eval examples.
def sampleAccount : Account :=
  { ownerId := 1, balance := 100 }

#eval sampleAccount.balance
