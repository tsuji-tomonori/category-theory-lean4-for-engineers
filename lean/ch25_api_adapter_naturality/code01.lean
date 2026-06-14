-- Source: chapters/ch25_api_adapter_naturality.tex:79

/-
Chapter 25: API adapter and naturality.
This file intentionally avoids Mathlib's CategoryTheory API.
It models only the small part needed for the chapter.
-/

namespace Chapter25

/-- Old API response wrapper. -/
structure OldResponse (A : Type) where
  status : Nat
  body : Option A
  requestId : String

/-- New API response wrapper. -/
structure NewResponse (A : Type) where
  code : Nat
  data : Option A
  requestId : String
  cached : Bool
