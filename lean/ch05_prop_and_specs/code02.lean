-- 出典: chapters/ch05_prop_and_specs.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def hasDiscount (member : Bool) : Bool :=
  member

def DiscountSpec (member : Bool) : Prop :=
  hasDiscount member = true

#check DiscountSpec true
#check DiscountSpec false
