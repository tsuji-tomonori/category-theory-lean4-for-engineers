-- 出典: chapters/ch07_variables_and_forall.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def addTax (price tax : Nat) : Nat :=
  price + tax

theorem addTax_zero (price : Nat) :
    addTax price 0 = price := by
  rfl
