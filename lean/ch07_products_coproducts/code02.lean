-- Source: chapters/ch07_products_coproducts.tex:93

-- Lean's A × B notation is Prod A B.
def loginPair : Nat × String := (42, "token")

example : loginPair.1 = 42 := rfl
example : loginPair.2 = "token" := rfl

-- A pair can be rebuilt from its two projections.
theorem prod_eta {A B : Type} (p : A × B) : (p.1, p.2) = p := by
  cases p
  rfl
