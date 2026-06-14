-- Source: chapters/ch02_props_specs.tex:314
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

theorem addTax_def (price tax : Nat) :
    addTax price tax = price + tax := by
  rfl
