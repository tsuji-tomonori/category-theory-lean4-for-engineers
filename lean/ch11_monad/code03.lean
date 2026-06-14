-- Source: chapters/ch11_monad.tex:196

/-! ## 失敗しうるユーザー移行 -/

structure UserDraft where
  id : Nat
  emailOpt : Option String
  ageOpt : Option Nat
  deriving Repr, DecidableEq

structure UserWithEmail where
  id : Nat
  email : String
  ageOpt : Option Nat
  deriving Repr, DecidableEq

structure UserV2 where
  id : Nat
  email : String
  age : Nat
  deriving Repr, DecidableEq
