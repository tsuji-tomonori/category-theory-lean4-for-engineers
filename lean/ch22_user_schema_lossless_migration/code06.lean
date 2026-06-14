-- 出典: chapters/ch22_user_schema_lossless_migration.tex:314
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

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

def rollback (v : UserV2) : UserV1 :=
  { id := v.userId
    name := v.profile.displayName
    email := v.contact.emailAddress
    emailVerified := v.contact.verified
    createdAt := v.audit.createdAt }

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

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

structure SchemaIso (A B : Type) where
  to : A -> B
  backward : B -> A
  backward_to : forall a, backward (to a) = a
  to_backward : forall b, to (backward b) = b

def userSchemaIso : SchemaIso UserV1 UserV2 :=
  { to := migrate
    backward := rollback
    backward_to := rollback_migrate
    to_backward := migrate_rollback }

def batchMigrate (users : List UserV1) : List UserV2 :=
  users.map migrate

def batchRollback (users : List UserV2) : List UserV1 :=
  users.map rollback

theorem batch_rollback_migrate (users : List UserV1) :
    batchRollback (batchMigrate users) = users := by
  induction users with
  | nil => rfl
  | cons u us ih =>
    unfold batchMigrate batchRollback at ih ⊢
    simp [rollback_migrate, ih]

end Chapter22
