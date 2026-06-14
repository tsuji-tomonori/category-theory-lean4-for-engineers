-- Source: chapters/appA_lean4_min_cheatsheet.tex:46

/-
Appendix A: Lean 4 minimal cheat sheet
This file mirrors the Lean snippets used in the appendix.
-/

def serviceFee : Nat := 300

def addFee (price : Nat) : Nat :=
  price + serviceFee

def inc (n : Nat) : Nat :=
  n + 1

def double (n : Nat) : Nat :=
  n * 2

def pipeline (n : Nat) : Nat :=
  double (inc n)

#eval addFee 1000
#eval pipeline 10
