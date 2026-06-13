/-
Chapter 29: 仕様・実装・テスト・証明の接続
This file contains the Lean snippets used in the chapter.
-/

namespace Chapter29

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

/--
SPEC-CHARGE-001:
実装モデル chargeImpl は仕様モデル chargeSpec と一致する。
前提: 金額は Nat。丸め、税率、外部決済APIはモデル外。
-/
theorem SPEC_CHARGE_001 (i : PriceInput) :
    chargeImpl i = chargeSpec i := by
  exact charge_impl_matches_spec i

end Chapter29
