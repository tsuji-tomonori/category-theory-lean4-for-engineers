-- Source: chapters/ch29_spec_impl_test_proof.tex:78

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
