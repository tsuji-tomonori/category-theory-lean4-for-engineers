-- Source: chapters/ch02_props_specs.tex:364
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def normalizePrice (price : Nat) : Nat :=
  price

theorem normalizePrice_eq (price : Nat) :
    normalizePrice price = price := by
  rfl

theorem addTax_after_normalize (price tax : Nat) :
    addTax (normalizePrice price) tax = addTax price tax := by
  rw [normalizePrice_eq]
