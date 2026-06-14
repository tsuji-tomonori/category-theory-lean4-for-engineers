-- 出典: chapters/ch00_map.tex:219
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

structure UserV1 where
  id : Nat
  name : String

deriving instance Repr for UserV1

structure UserV2 where
  id : Nat
  profileName : String

deriving instance Repr for UserV2

def migrate (u : UserV1) : UserV2 :=
  { id := u.id, profileName := u.name }

def rollback (v : UserV2) : UserV1 :=
  { id := v.id, name := v.profileName }

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v
  rfl
