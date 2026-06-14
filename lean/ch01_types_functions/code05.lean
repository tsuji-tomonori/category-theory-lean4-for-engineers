-- Source: chapters/ch01_types_functions.tex:352

#check addOne
#check (fun (n : Nat) => n + 1)

def inc : Nat -> Nat :=
  fun n => n + 1

def applyTwice (f : Nat -> Nat) (x : Nat) : Nat :=
  f (f x)

#eval inc 4
#eval applyTwice inc 10
#eval applyTwice (fun n => n + 2) 10
