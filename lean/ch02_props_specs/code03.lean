-- Source: chapters/ch02_props_specs.tex:167

-- A specification can be separated from the function it describes.
def addTax (price tax : Nat) : Nat :=
  price + tax

#eval addTax 1000 100

def TaxSpec (price tax total : Nat) : Prop :=
  total = addTax price tax

example : TaxSpec 1000 100 1100 := by
  rfl
