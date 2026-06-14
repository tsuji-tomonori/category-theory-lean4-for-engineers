-- Source: chapters/ch09_natural_transformation.tex:312

/-- A tiny response status used in the API wrapper example. -/
inductive Status where
  | ok
  | empty
  deriving Repr, DecidableEq

/-- Old API wrapper: at most one payload. -/
structure OldResponse (A : Type) where
  traceId : Nat
  payload : Option A
  deriving Repr

/-- New API wrapper: zero or more payload items plus status. -/
structure NewResponse (A : Type) where
  traceId : Nat
  status : Status
  items : List A
  deriving Repr

/-- Status depends only on whether the payload exists, not on its value. -/
def statusOf {A : Type} : Option A -> Status
  | none => Status.empty
  | some _ => Status.ok
