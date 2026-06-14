-- Source: chapters/ch02_props_specs.tex:220

theorem addTax_zero (price : Nat) :
    addTax price 0 = price := by
  simp [addTax]

-- example is useful for local checks.
def SamePrice (before after : Nat) : Prop :=
  before = after

example : SamePrice 1200 1200 := by
  rfl
