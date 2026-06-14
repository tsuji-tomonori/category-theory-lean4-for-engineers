-- Source: chapters/ch01_types_functions.tex:101

/-
Chapter 1: 型・値・関数
Lean 4 examples used in chapters/ch01_types_functions.tex.
These examples intentionally avoid Mathlib and advanced proof features.
-/

#check Nat
#check Bool
#check String

#check (3 : Nat)
#check (true : Bool)
#check ("lean" : String)

#check List Nat
#check Option String
