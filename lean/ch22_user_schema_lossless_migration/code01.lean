-- 出典: chapters/ch22_user_schema_lossless_migration.tex:129
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter22

structure UserV1 where
  id : Nat
  name : String
  email : String
  emailVerified : Bool
  createdAt : Nat
  deriving Repr, DecidableEq

structure Profile where
  displayName : String
  deriving Repr, DecidableEq

structure Contact where
  emailAddress : String
  verified : Bool
  deriving Repr, DecidableEq

structure Audit where
  createdAt : Nat
  deriving Repr, DecidableEq

structure UserV2 where
  userId : Nat
  profile : Profile
  contact : Contact
  audit : Audit
  deriving Repr, DecidableEq
