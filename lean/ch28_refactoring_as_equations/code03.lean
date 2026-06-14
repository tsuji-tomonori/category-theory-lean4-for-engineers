-- Source: chapters/ch28_refactoring_as_equations.tex:131

-- 順序を変えると意味が変わる例。
def double (n : Nat) : Nat := n * 2

def addOne (n : Nat) : Nat := n + 1

example : double (addOne 3) ≠ addOne (double 3) := by
  decide
