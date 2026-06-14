-- Source: chapters/ch06_isomorphism.tex:253
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

structure UserV1 where
  id : Nat
  email : String
  displayName : String
deriving Repr, DecidableEq

structure Contact where
  email : String
deriving Repr, DecidableEq

structure Profile where
  displayName : String
deriving Repr, DecidableEq

structure UserV2 where
  userId : Nat
  contact : Contact
  profile : Profile
deriving Repr, DecidableEq
