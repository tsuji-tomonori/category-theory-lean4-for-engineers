-- 出典: chapters/appD_migration_proof_checklist.tex:192
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

structure UserV1 where
  id : Nat
  name : String
deriving Repr

structure Profile where
  displayName : String
deriving Repr

structure UserV2 where
  id : Nat
  profile : Profile
deriving Repr

def migrateUser : UserV1 -> UserV2 :=
  fun u =>
    { id := u.id
      profile := { displayName := u.name } }

def rollbackUser : UserV2 -> UserV1 :=
  fun u =>
    { id := u.id
      name := u.profile.displayName }
