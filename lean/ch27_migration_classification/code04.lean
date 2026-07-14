-- 出典: chapters/ch27_migration_classification.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter27

structure EquivMini (A B : Type) where
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

def userIso : EquivMini UserV1 UserV2 :=
  { toFun := migrateUser
    invFun := rollbackUser
    left_inv := user_left_roundtrip
    right_inv := user_right_roundtrip }

structure OldToken where
  token : String
  deriving DecidableEq, Repr

structure NewToken where
  token : String
  issuedAt : Nat
  deriving DecidableEq, Repr

def oldToNew (o : OldToken) : NewToken :=
  { token := o.token, issuedAt := 0 }

def newToOld (n : NewToken) : OldToken :=
  { token := n.token }

theorem old_roundtrip (o : OldToken) :
    newToOld (oldToNew o) = o := by
  cases o
  rfl

def IsDefaultIssuedAt (n : NewToken) : Prop :=
  n.issuedAt = 0

theorem new_roundtrip_when_default
    (n : NewToken) (h : IsDefaultIssuedAt n) :
    oldToNew (newToOld n) = n := by
  cases n with
  | mk token issuedAt =>
      unfold IsDefaultIssuedAt at h
      simp at h
      cases h
      rfl

structure PrivateLog where
  userId : Nat
  message : String
  deriving DecidableEq, Repr

structure PublicLog where
  message : String
  deriving DecidableEq, Repr

def anonymize (l : PrivateLog) : PublicLog :=
  { message := l.message }

def SamePublicView (x y : PrivateLog) : Prop :=
  anonymize x = anonymize y

theorem anonymize_preserves_message (l : PrivateLog) :
    (anonymize l).message = l.message := by
  rfl

theorem different_users_can_have_same_public_view (msg : String) :
    SamePublicView { userId := 1, message := msg }
                   { userId := 2, message := msg } := by
  rfl

inductive MigrationKind : Type where
  | fullIso
  | oneWayCompatible
  | lossy
  | conditionalIso
  | weakenedSpec
  deriving DecidableEq, Repr

end Chapter27
