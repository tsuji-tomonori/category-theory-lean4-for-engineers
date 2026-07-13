-- 出典: chapters/ch01_reading_code.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def greeting : String :=
  "hello"

def addOne (n : Nat) : Nat :=
  n + 1

#check addOne
#eval greeting
#eval addOne 5
