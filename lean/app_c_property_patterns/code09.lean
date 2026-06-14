-- Source: chapters/app_c_property_patterns.tex:450

structure Account where
  balance : Nat

def NonNegative (a : Account) : Prop :=
  0 <= a.balance

def deposit (amount : Nat) (a : Account) : Account :=
  { balance := a.balance + amount }

theorem deposit_preserves_nonnegative
    (amount : Nat) (a : Account) :
    NonNegative a -> NonNegative (deposit amount a) := by
  intro h
  unfold NonNegative deposit
  exact Nat.zero_le (a.balance + amount)
