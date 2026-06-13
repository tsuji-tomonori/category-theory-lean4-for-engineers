/-
Chapter 2: Propositions, proofs, and specifications.
The examples in this file are intentionally small and use Lean 4's core features.
-/

namespace Ch02PropsSpecs

-- Bool is a value computed by a program.
def hasDiscount (member : Bool) : Bool :=
  member

#eval hasDiscount true
#eval hasDiscount false

-- Prop is a proposition that we want to prove.
def DiscountSpec (member : Bool) : Prop :=
  hasDiscount member = true

theorem member_hasDiscount : DiscountSpec true := by
  rfl

-- A specification can be separated from the function it describes.
def addTax (price tax : Nat) : Nat :=
  price + tax

#eval addTax 1000 100

def TaxSpec (price tax total : Nat) : Prop :=
  total = addTax price tax

example : TaxSpec 1000 100 1100 := by
  rfl

theorem addTax_zero (price : Nat) :
    addTax price 0 = price := by
  simp [addTax]

-- example is useful for local checks.
def SamePrice (before after : Nat) : Prop :=
  before = after

example : SamePrice 1200 1200 := by
  rfl

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

theorem addTax_after_normalize (price tax : Nat) :
    addTax (normalizePrice price) tax = addTax price tax := by
  rw [normalizePrice_eq]

-- Named theorems can be reused as specifications.
theorem addTax_rewrite_example (price tax : Nat) :
    addTax price tax = tax + price := by
  rw [addTax_def]
  rw [Nat.add_comm]

-- A small DTO example: conversion preserves the user ID.
structure UserInput where
  id : Nat
  nameCode : Nat

structure UserDto where
  id : Nat
  displayCode : Nat

def toDto (u : UserInput) : UserDto :=
  { id := u.id, displayCode := u.nameCode }

def PreservesId (f : UserInput -> UserDto) : Prop :=
  forall u, (f u).id = u.id

theorem toDto_preservesId : PreservesId toDto := by
  intro u
  rfl

end Ch02PropsSpecs
