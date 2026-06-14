-- Source: chapters/ch21_migration_classification.tex:120

/-- フィールド名変更前のユーザー。 -/
structure UserV1 where
  id : Nat
  name : String
  deriving DecidableEq, Repr

/-- フィールド名変更後のユーザー。 -/
structure UserV2 where
  id : Nat
  profileName : String
  deriving DecidableEq, Repr

/-- 情報を失わない移行。 -/
def migrateUser (u : UserV1) : UserV2 :=
  { id := u.id, profileName := u.name }

/-- 情報を失わない逆変換。 -/
def rollbackUser (v : UserV2) : UserV1 :=
  { id := v.id, name := v.profileName }

/-- 旧形式から新形式へ移して戻すと元に戻る。 -/
theorem user_left_roundtrip (u : UserV1) :
    rollbackUser (migrateUser u) = u := by
  cases u
  rfl

/-- 新形式から旧形式へ戻して移すと元に戻る。 -/
theorem user_right_roundtrip (v : UserV2) :
    migrateUser (rollbackUser v) = v := by
  cases v
  rfl
