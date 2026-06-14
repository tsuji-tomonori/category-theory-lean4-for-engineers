-- Source: chapters/ch01_types_functions.tex:250

def answer : Nat :=
  42

def addOne (n : Nat) : Nat :=
  n + 1

def add (m : Nat) (n : Nat) : Nat :=
  m + n

def joinWithSpace (left : String) (right : String) : String :=
  left ++ " " ++ right

#check answer
#check addOne
#check add

#eval addOne 5
#eval add 2 3
#eval joinWithSpace "Lean" "4"
