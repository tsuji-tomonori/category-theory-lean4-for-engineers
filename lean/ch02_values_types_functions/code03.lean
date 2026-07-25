-- 出典: chapters/ch02_values_types_functions.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def addOne (n : Nat) : Nat :=
  n + 1

def add (m : Nat) (n : Nat) : Nat :=
  m + n

#check addOne
-- 出力: addOne (n : Nat) : Nat
#check add
-- 出力: add (m n : Nat) : Nat
