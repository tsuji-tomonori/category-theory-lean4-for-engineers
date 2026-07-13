-- 出典: chapters/ch35_spec_impl_test_proof.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter35

structure PriceInput where
  base : Nat
  discount : Nat
  shipping : Nat

def chargeSpec (i : PriceInput) : Nat :=
  (i.base - i.discount) + i.shipping

def chargeImpl (i : PriceInput) : Nat :=
  let subtotal := i.base - i.discount
  subtotal + i.shipping

theorem charge_impl_matches_spec (i : PriceInput) :
    chargeImpl i = chargeSpec i := by
  rfl

#eval chargeImpl { base := 100, discount := 10, shipping := 5 }

example :
    chargeImpl { base := 100, discount := 10, shipping := 5 } = 95 := by
  rfl

example :
    chargeImpl { base := 8, discount := 10, shipping := 5 } = 5 := by
  rfl

def withdrawCore (balance amount : Nat) : Option Nat :=
  if _h : amount <= balance then
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
