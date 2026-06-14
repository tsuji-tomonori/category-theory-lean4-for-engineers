-- Source: chapters/ch08_functor.tex:310

-- 実務例：一件のユーザー移行。
structure UserV1 where
  id : Nat
  name : String
deriving Repr

structure UserV2 where
  userId : Nat
  displayName : String

deriving instance Repr for UserV2

def migrateUser (u : UserV1) : UserV2 :=
  { userId := u.id, displayName := u.name }
