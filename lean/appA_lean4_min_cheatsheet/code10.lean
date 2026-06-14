-- Source: chapters/appA_lean4_min_cheatsheet.tex:293

def isSomeNat (x : Option Nat) : Bool :=
  match x with
  | none => false
  | some _ => true

theorem isSomeNat_cases (x : Option Nat) :
    isSomeNat x = true \/ isSomeNat x = false := by
  cases x with
  | none =>
      exact Or.inr rfl
  | some n =>
      exact Or.inl rfl
