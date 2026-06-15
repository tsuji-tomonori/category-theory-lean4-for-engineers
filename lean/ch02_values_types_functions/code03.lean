-- 出典: chapters/ch02_values_types_functions.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def addOne (n : Nat) : Nat :=
  n + 1

def add (m : Nat) (n : Nat) : Nat :=
  m + n

#check addOne
#check add
