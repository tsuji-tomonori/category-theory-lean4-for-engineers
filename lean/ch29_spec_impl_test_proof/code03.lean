-- Source: chapters/ch29_spec_impl_test_proof.tex:203

def withdrawCore (balance amount : Nat) : Option Nat :=
  if h : amount <= balance then
    some (balance - amount)
  else
    none

theorem withdrawCore_success
    (balance amount : Nat) (h : amount <= balance) :
    withdrawCore balance amount = some (balance - amount) := by
  simp [withdrawCore, h]

theorem withdrawCore_failure
    (balance amount : Nat) (h : ¬ (amount <= balance)) :
    withdrawCore balance amount = none := by
  simp [withdrawCore, h]
