-- Source: chapters/ch21_migration_classification.tex:212

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
