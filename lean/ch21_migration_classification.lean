/-
Chapter 21: マイグレーションを数学的に分類する

このファイルは本文中の Lean コードをまとめたものです。
Mathlib の高度な圏論 API は使わず、標準的な Lean 4 だけで
マイグレーションの分類を小さく表します。
-/

namespace Ch21MigrationClassification

/-- 完全同型を表す最小構造。 -/
structure EquivLike (A B : Type) where
  toFun : A -> B
  invFun : B -> A
  left_inv : (a : A) -> invFun (toFun a) = a
  right_inv : (b : B) -> toFun (invFun b) = b

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

/-- 追加フィールドがデフォルト値である、という well-formed 条件。 -/
def IsDefaultIssuedAt (n : NewToken) : Prop :=
  n.issuedAt = 0

/-- well-formed な新データだけなら、戻して移しても元に戻る。 -/
theorem new_roundtrip_when_default
    (n : NewToken) (h : IsDefaultIssuedAt n) :
    oldToNew (newToOld n) = n := by
  cases n with
  | mk token issuedAt =>
      unfold IsDefaultIssuedAt at h
      simp at h
      cases h
      rfl

/-- 内部ログ。 -/
structure PrivateLog where
  userId : Nat
  message : String
  deriving DecidableEq, Repr

/-- 公開ログ。 -/
structure PublicLog where
  message : String
  deriving DecidableEq, Repr

/-- 匿名化。ユーザーIDは落とす。 -/
def anonymize (l : PrivateLog) : PublicLog :=
  { message := l.message }

/-- 公開ログとして同じ見え方をする、という関係。 -/
def SamePublicView (x y : PrivateLog) : Prop :=
  anonymize x = anonymize y

/-- 匿名化してもメッセージ本文は保存される。 -/
theorem anonymize_preserves_message (l : PrivateLog) :
    (anonymize l).message = l.message := by
  rfl

/-- 異なるユーザーでも、公開ログとしては同じになることがある。 -/
theorem different_users_can_have_same_public_view (msg : String) :
    SamePublicView { userId := 1, message := msg }
                   { userId := 2, message := msg } := by
  rfl

/-- 本章で使う分類名。 -/
inductive MigrationKind : Type where
  | fullIso
  | oneWayCompatible
  | lossy
  | conditionalIso
  | weakenedSpec
  deriving DecidableEq, Repr

end Ch21MigrationClassification
