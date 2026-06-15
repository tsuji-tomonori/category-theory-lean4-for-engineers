-- 出典: chapters/ch04_rfl.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def hasDiscount (member : Bool) : Bool :=
  member

example : hasDiscount true = true := by
  rfl
