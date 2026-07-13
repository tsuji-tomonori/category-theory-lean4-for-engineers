-- 出典: chapters/ch36_team_operations.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter36

structure UserV1 where
  id : Nat
  name : String
  deriving Repr, DecidableEq

structure UserV2 where
  id : Nat
  displayName : String
  deriving Repr, DecidableEq

def migrate (u : UserV1) : UserV2 :=
  { id := u.id, displayName := u.name }

def rollback (u : UserV2) : UserV1 :=
  { id := u.id, name := u.displayName }

theorem userV1_rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl
