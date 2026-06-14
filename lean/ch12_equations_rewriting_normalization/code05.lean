-- Source: chapters/ch12_equations_rewriting_normalization.tex:219

def addFee (amount fee : Nat) : Nat :=
  amount + fee

def legacyWithTwoFees
    (base service shipping : Nat) : Nat :=
  addFee (addFee base service) shipping

def refactoredWithTwoFees
    (base service shipping : Nat) : Nat :=
  addFee base (service + shipping)

theorem twoFees_eq_calc
    (base service shipping : Nat) :
    legacyWithTwoFees base service shipping =
      refactoredWithTwoFees base service shipping := by
  calc
    legacyWithTwoFees base service shipping
        = (base + service) + shipping := by rfl
    _ = base + (service + shipping) := by
          rw [Nat.add_assoc]
    _ = refactoredWithTwoFees base service shipping := by rfl
