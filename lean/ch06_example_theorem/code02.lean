-- 出典: chapters/ch06_example_theorem.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def addTax (price tax : Nat) : Nat :=
  price + tax

def TaxSpec (price tax total : Nat) : Prop :=
  total = addTax price tax

example : TaxSpec 1000 100 1100 := by
  rfl
