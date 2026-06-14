-- Source: chapters/ch07_products_coproducts.tex:47

/-
Chapter 7: Products and coproducts for software engineers.
This file mirrors the Lean snippets used in the chapter.
It intentionally avoids Mathlib's CategoryTheory API.
-/

namespace Ch07

structure UserSummary where
  id   : Nat
  name : String
