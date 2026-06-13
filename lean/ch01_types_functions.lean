/-
Chapter 1: 型・値・関数
Lean 4 examples used in chapters/ch01_types_functions.tex.
These examples intentionally avoid Mathlib and advanced proof features.
-/

#check Nat
#check Bool
#check String
#check List Nat
#check Option String

#eval (3 : Nat) + 4
#eval true && false
#eval "lean" ++ "4"
#eval [1, 2, 3].length
#eval (some "alice" : Option String)

def addTax10 (price : Nat) : Nat :=
  price + price / 10

def isLarge (price : Nat) : Bool :=
  decide (1000 <= price)

def labelBySize (price : Nat) : String :=
  if isLarge price then "large" else "small"

#eval addTax10 1200
#eval labelBySize 900
#eval labelBySize (addTax10 1000)

def findUserName (userId : Nat) : Option String :=
  if userId == 1 then some "alice"
  else if userId == 2 then some "bob"
  else none

def greeting (name : String) : String :=
  "hello, " ++ name

def greetingById (userId : Nat) : String :=
  match findUserName userId with
  | some name => greeting name
  | none => "unknown user"

#eval greetingById 1
#eval greetingById 3

def keepAsIs (s : String) : String :=
  s

def addUserPrefix (s : String) : String :=
  "user:" ++ s

def addExampleDomain (s : String) : String :=
  s ++ "@example.com"

def normalizeUserName (s : String) : String :=
  addExampleDomain (addUserPrefix (keepAsIs s))

def compose {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)

def normalizeUserName' : String -> String :=
  compose addExampleDomain (compose addUserPrefix keepAsIs)

#eval normalizeUserName "alice"
#eval normalizeUserName' "alice"

def rejectEmpty (s : String) : Option String :=
  if s == "" then none else some s

def canonicalUserId (s : String) : Option String :=
  match rejectEmpty s with
  | none => none
  | some name => some (normalizeUserName name)

def normalizeAll (names : List String) : List (Option String) :=
  names.map canonicalUserId

#eval canonicalUserId ""
#eval canonicalUserId "alice"
#eval normalizeAll ["alice", "", "bob"]
