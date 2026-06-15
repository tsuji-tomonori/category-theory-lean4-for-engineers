-- 出典: chapters/ch22_user_schema_lossless_migration.tex:178
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

def migrate (u : UserV1) : UserV2 :=
  { userId := u.id
    profile := { displayName := u.name }
    contact :=
      { emailAddress := u.email
        verified := u.emailVerified }
    audit := { createdAt := u.createdAt } }

#eval migrate
  { id := 1
    name := "Ada"
    email := "ada@example.com"
    emailVerified := true
    createdAt := 1000 }
