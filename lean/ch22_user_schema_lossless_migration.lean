/-
第22章 ケーススタディ：User スキーマの lossless migration

このファイルは、本文中の Lean コードを抽出したものです。
標準ライブラリだけで読める小さなモデルとして書いています。
-/

namespace Chapter22

structure UserV1 where
  id : Nat
  name : String
  email : String
  emailVerified : Bool
  createdAt : Nat
  deriving Repr, DecidableEq

structure Profile where
  displayName : String
  deriving Repr, DecidableEq

structure Contact where
  emailAddress : String
  verified : Bool
  deriving Repr, DecidableEq

structure Audit where
  createdAt : Nat
  deriving Repr, DecidableEq

structure UserV2 where
  userId : Nat
  profile : Profile
  contact : Contact
  audit : Audit
  deriving Repr, DecidableEq

-- 旧スキーマから新スキーマへ移す。
def migrate (u : UserV1) : UserV2 :=
  { userId := u.id
    profile := { displayName := u.name }
    contact :=
      { emailAddress := u.email
        verified := u.emailVerified }
    audit := { createdAt := u.createdAt } }

#eval migrate
  { id := 1
    name := "Ada"
    email := "ada@example.com"
    emailVerified := true
    createdAt := 1000 }

-- 新スキーマから旧スキーマへ戻す。
def rollback (v : UserV2) : UserV1 :=
  { id := v.userId
    name := v.profile.displayName
    email := v.contact.emailAddress
    emailVerified := v.contact.verified
    createdAt := v.audit.createdAt }

-- 旧データを新形式へ移し、旧形式へ戻すと元に戻る。
theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

-- 新データを旧形式へ戻し、再び新形式へ移すと元に戻る。
theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk userId profile contact audit =>
    cases profile with
    | mk displayName =>
      cases contact with
      | mk emailAddress verified =>
        cases audit with
        | mk createdAt =>
          rfl

-- 二つの変換関数と二つの round-trip 証明をまとめる。
structure SchemaIso (A B : Type) where
  to : A -> B
  from : B -> A
  from_to : forall a, from (to a) = a
  to_from : forall b, to (from b) = b

-- UserV1 と UserV2 は、このモデル上では同型である。
def userSchemaIso : SchemaIso UserV1 UserV2 :=
  { to := migrate
    from := rollback
    from_to := rollback_migrate
    to_from := migrate_rollback }

-- 次章への橋渡し：一件の round-trip は、map でリスト全体にも使える。
def batchMigrate (users : List UserV1) : List UserV2 :=
  users.map migrate

def batchRollback (users : List UserV2) : List UserV1 :=
  users.map rollback

theorem batch_rollback_migrate (users : List UserV1) :
    batchRollback (batchMigrate users) = users := by
  induction users with
  | nil => rfl
  | cons u us ih =>
    simp [batchMigrate, batchRollback, rollback_migrate, ih]

end Chapter22
