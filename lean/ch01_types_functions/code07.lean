-- 出典: chapters/ch01_types_functions.tex:469
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

#check Nat
#check Bool
#check String

#check (3 : Nat)
#check (true : Bool)
#check ("lean" : String)

#check List Nat
#check Option String

#eval (3 : Nat) + 4
#eval true && false
#eval "lean" ++ "4"

#eval ([1, 2, 3] : List Nat).length
#eval ([true, false] : List Bool)

#eval (some 3 : Option Nat)
#eval (none : Option Nat)

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

#eval answer
#eval addOne answer
#eval addOne (addOne 10)
#eval add (addOne 2) (addOne 3)
#eval joinWithSpace (joinWithSpace "Lean" "4") "book"

#check addOne
#check (fun (n : Nat) => n + 1)

def inc : Nat -> Nat :=
  fun n => n + 1

def applyTwice (f : Nat -> Nat) (x : Nat) : Nat :=
  f (f x)

#eval inc 4
#eval applyTwice inc 10
#eval applyTwice (fun n => n + 2) 10

def compose {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)

def surround (s : String) : String :=
  "[" ++ s ++ "]"

def mark (s : String) : String :=
  s ++ "!"

def transform : String -> String :=
  compose mark surround

#eval transform "x"
#eval compose addOne addOne 10

def nonempty (s : String) : Option String :=
  if s == "" then none else some s

def decorate (s : String) : String :=
  mark (surround s)

def decorateIfNonempty (s : String) : Option String :=
  match nonempty s with
  | none => none
  | some value => some (decorate value)

def decorateAll (xs : List String) : List (Option String) :=
  xs.map decorateIfNonempty

#eval decorateIfNonempty ""
#eval decorateIfNonempty "lean"
#eval decorateAll ["a", "", "b"]
