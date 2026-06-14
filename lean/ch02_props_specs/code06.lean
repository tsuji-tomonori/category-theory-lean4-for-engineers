-- Source: chapters/ch02_props_specs.tex:276

-- rfl proves equalities that are the same after unfolding definitions.
theorem addTax_def (price tax : Nat) :
    addTax price tax = price + tax := by
  rfl

-- simp can simplify definitions and obvious branches.
def chargeShipping (isMember : Bool) (shipping : Nat) : Nat :=
  if isMember then 0 else shipping

theorem member_shipping_zero (shipping : Nat) :
    chargeShipping true shipping = 0 := by
  simp [chargeShipping]

-- rw uses a known equality to rewrite the goal.
def normalizePrice (price : Nat) : Nat :=
  price

theorem normalizePrice_eq (price : Nat) :
    normalizePrice price = price := by
  rfl
