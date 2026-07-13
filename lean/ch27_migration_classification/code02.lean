-- 出典: chapters/ch27_migration_classification.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter27

structure EquivLike (A B : Type) where
  toFun : A -> B
  invFun : B -> A
  left_inv : (a : A) -> invFun (toFun a) = a
  right_inv : (b : B) -> toFun (invFun b) = b

structure UserV1 where
  id : Nat
  name : String
  deriving DecidableEq, Repr

structure UserV2 where
  id : Nat
  profileName : String
  deriving DecidableEq, Repr

def migrateUser (u : UserV1) : UserV2 :=
  { id := u.id, profileName := u.name }

def rollbackUser (v : UserV2) : UserV1 :=
  { id := v.id, name := v.profileName }

theorem user_left_roundtrip (u : UserV1) :
    rollbackUser (migrateUser u) = u := by
  cases u
  rfl

theorem user_right_roundtrip (v : UserV2) :
    migrateUser (rollbackUser v) = v := by
  cases v
  rfl
