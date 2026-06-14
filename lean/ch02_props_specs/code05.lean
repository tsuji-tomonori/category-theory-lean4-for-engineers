-- Source: chapters/ch02_props_specs.tex:241
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

theorem addTax_zero (price : Nat) :
    addTax price 0 = price := by
  simp [addTax]
