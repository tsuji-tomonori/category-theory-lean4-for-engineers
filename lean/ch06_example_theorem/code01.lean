-- 出典: chapters/ch06_example_theorem.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def hasDiscount (member : Bool) : Bool :=
  member

def DiscountSpec (member : Bool) : Prop :=
  hasDiscount member = true

theorem member_hasDiscount : DiscountSpec true := by
  rfl

-- これは証明できない。
-- DiscountSpec false は展開すると false = true になる。
-- theorem nonmember_hasDiscount : DiscountSpec false := by
--   rfl
