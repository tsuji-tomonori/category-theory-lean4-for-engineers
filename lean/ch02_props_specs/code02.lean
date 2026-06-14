-- Source: chapters/ch02_props_specs.tex:88

-- Prop is a proposition that we want to prove.
def DiscountSpec (member : Bool) : Prop :=
  hasDiscount member = true

theorem member_hasDiscount : DiscountSpec true := by
  rfl
