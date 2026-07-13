-- 出典: chapters/ch29_lossy_migration.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter29

structure FullName where
  first : String
  middle : Option String
  last : String
deriving Repr, DecidableEq

structure UserV1 where
  id : Nat
  fullName : FullName
deriving Repr, DecidableEq

structure UserV2 where
  id : Nat
  firstName : String
  lastName : String
deriving Repr, DecidableEq

def migrate (u : UserV1) : UserV2 :=
  { id := u.id,
    firstName := u.fullName.first,
    lastName := u.fullName.last }

def rollback (v : UserV2) : UserV1 :=
  { id := v.id,
    fullName :=
      { first := v.firstName,
        middle := none,
        last := v.lastName } }

theorem new_round_trip (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk id firstName lastName =>
      rfl
