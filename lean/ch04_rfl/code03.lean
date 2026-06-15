-- 出典: chapters/ch04_rfl.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def addTax (price tax : Nat) : Nat :=
  price + tax

example : addTax 100 0 = 100 := by
  rfl
