-- Source: chapters/ch12_equations_rewriting_normalization.tex:271

def chargeLegacy
    (base discount service shipping : Nat) : Nat :=
  addTax
    (addFee (addFee (subtotal base discount) service) shipping)
    0

def chargeNormalized
    (base discount service shipping : Nat) : Nat :=
  (base - discount) + (service + shipping)

theorem chargeLegacy_eq_chargeNormalized
    (base discount service shipping : Nat) :
    chargeLegacy base discount service shipping =
      chargeNormalized base discount service shipping := by
  unfold chargeLegacy chargeNormalized subtotal addFee addTax
  simp [Nat.add_assoc]


end Ch12
