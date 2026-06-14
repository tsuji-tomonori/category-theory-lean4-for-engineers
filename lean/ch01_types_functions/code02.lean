-- 出典: chapters/ch01_types_functions.tex:196
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
