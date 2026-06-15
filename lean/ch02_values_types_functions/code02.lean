-- 出典: chapters/ch02_values_types_functions.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def answer : Nat :=
  42

def addOne (n : Nat) : Nat :=
  n + 1

def add (m : Nat) (n : Nat) : Nat :=
  m + n

#eval answer
#eval addOne 5
#eval add 2 3
