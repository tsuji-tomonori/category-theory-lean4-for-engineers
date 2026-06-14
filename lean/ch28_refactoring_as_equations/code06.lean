-- Source: chapters/ch28_refactoring_as_equations.tex:226

-- Option を使った effectful code の整理。
def parsePositive (n : Nat) : Option Nat :=
  if n = 0 then none else some n

def checkEven (n : Nat) : Option Nat :=
  if n % 2 = 0 then some n else none

def enrich (n : Nat) : Option Nat :=
  some (n + 1)

def flowBefore (n : Nat) : Option Nat :=
  Option.bind (parsePositive n) (fun x =>
    Option.bind (checkEven x) enrich)

def flowAfter (n : Nat) : Option Nat :=
  Option.bind (Option.bind (parsePositive n) checkEven) enrich
