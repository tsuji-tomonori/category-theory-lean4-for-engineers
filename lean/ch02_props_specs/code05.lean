-- 出典: chapters/ch02_props_specs.tex:241
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch02PropsSpecs

def hasDiscount (member : Bool) : Bool :=
  member

#eval hasDiscount true
#eval hasDiscount false

def DiscountSpec (member : Bool) : Prop :=
  hasDiscount member = true

theorem member_hasDiscount : DiscountSpec true := by
  rfl

def addTax (price tax : Nat) : Nat :=
  price + tax

#eval addTax 1000 100

def TaxSpec (price tax total : Nat) : Prop :=
  total = addTax price tax

example : TaxSpec 1000 100 1100 := by
  rfl

theorem addTax_zero (price : Nat) :
    addTax price 0 = price := by
  simp [addTax]

def SamePrice (before after : Nat) : Prop :=
  before = after

example : SamePrice 1200 1200 := by
  rfl
