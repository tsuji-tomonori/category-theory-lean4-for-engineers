-- Source: chapters/ch02_props_specs.tex:448

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
