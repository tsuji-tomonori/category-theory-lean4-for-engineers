-- 出典: chapters/ch20_induction.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter20

structure UserV1 where
  id : Nat
  name : String
  deriving Repr, BEq

structure UserV2 where
  id : Nat
  displayName : String
  deriving Repr, BEq

def migrateUser (u : UserV1) : UserV2 :=
  { id := u.id, displayName := u.name }

def migrateUsers (xs : List UserV1) : List UserV2 :=
  xs.map migrateUser
