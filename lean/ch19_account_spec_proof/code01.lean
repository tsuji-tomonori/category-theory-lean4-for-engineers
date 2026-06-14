-- Source: chapters/ch19_account_spec_proof.tex:87

/-
Chapter 19: Account operation specification proofs.
This file contains the Lean 4 snippets used by chapters/ch19_account_spec_proof.tex.
-/

namespace Chapter19

abbrev AccountId := Nat
abbrev Balance := Nat
abbrev Amount := Nat

structure Account where
  id : AccountId
  balance : Balance
deriving Repr, DecidableEq

def NonNegative (a : Account) : Prop :=
  0 <= a.balance

theorem account_nonnegative (a : Account) : NonNegative a := by
  exact Nat.zero_le a.balance
