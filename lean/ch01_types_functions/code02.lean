-- Source: chapters/ch01_types_functions.tex:196

#eval (3 : Nat) + 4
#eval true && false
#eval "lean" ++ "4"

#eval ([1, 2, 3] : List Nat).length
#eval ([true, false] : List Bool)

#eval (some 3 : Option Nat)
#eval (none : Option Nat)
