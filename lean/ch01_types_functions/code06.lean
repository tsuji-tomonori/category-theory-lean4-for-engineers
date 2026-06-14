-- Source: chapters/ch01_types_functions.tex:408

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
