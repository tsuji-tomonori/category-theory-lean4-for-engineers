-- Source: chapters/ch04_invariants.tex:346

-- A withdrawal operation that can fail.
def withdrawOpt (a : Account) (amount : Nat) : Option Account :=
  if h : amount <= a.balance then
    some { a with balance := a.balance - amount }
  else
    none

#eval withdrawOpt sampleAccount 40
#eval withdrawOpt sampleAccount 150
