-- Source: chapters/ch02_props_specs.tex:408
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def addTax (price tax : Nat) : Nat :=
  price + tax

def TaxSpec (price tax total : Nat) : Prop :=
  total = addTax price tax

example : TaxSpec 1000 100 1100 := by
  rfl

theorem addTax_zero (price : Nat) :
    addTax price 0 = price := by
  simp [addTax]
