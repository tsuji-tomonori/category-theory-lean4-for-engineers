-- 出典: chapters/app_c_property_patterns.tex:87
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

structure UserV1 where
  id : Nat
  name : String

deriving Repr

structure UserV2 where
  id : Nat
  profileName : String

deriving Repr

def migrate (u : UserV1) : UserV2 :=
  { id := u.id, profileName := u.name }

def rollback (u : UserV2) : UserV1 :=
  { id := u.id, name := u.profileName }

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl
