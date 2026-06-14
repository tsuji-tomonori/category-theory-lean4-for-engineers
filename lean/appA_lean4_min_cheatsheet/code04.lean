-- Source: chapters/appA_lean4_min_cheatsheet.tex:137

inductive Result (A : Type) where
  | ok : A -> Result A
  | err : String -> Result A

def validatePositive (n : Nat) : Result Nat :=
  if n = 0 then
    Result.err "zero is not positive"
  else
    Result.ok n
