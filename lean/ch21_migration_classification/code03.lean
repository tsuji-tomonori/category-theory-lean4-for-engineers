-- Source: chapters/ch21_migration_classification.tex:168

/-- フィールド名変更は完全同型としてまとめられる。 -/
def userIso : EquivLike UserV1 UserV2 :=
  { toFun := migrateUser
    invFun := rollbackUser
    left_inv := user_left_roundtrip
    right_inv := user_right_roundtrip }

/-- フィールド追加前のトークン。 -/
structure OldToken where
  token : String
  deriving DecidableEq, Repr

/-- フィールド追加後のトークン。 -/
structure NewToken where
  token : String
  issuedAt : Nat
  deriving DecidableEq, Repr

/-- 旧形式を新形式へ移す。追加フィールドにはデフォルト値を入れる。 -/
def oldToNew (o : OldToken) : NewToken :=
  { token := o.token, issuedAt := 0 }

/-- 新形式を旧形式へ戻す。追加フィールドは落ちる。 -/
def newToOld (n : NewToken) : OldToken :=
  { token := n.token }

/-- 旧データについては、移して戻すと元に戻る。 -/
theorem old_roundtrip (o : OldToken) :
    newToOld (oldToNew o) = o := by
  cases o
  rfl
