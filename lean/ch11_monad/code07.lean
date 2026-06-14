-- Source: chapters/ch11_monad.tex:320

example : migrateUser goodDraft =
    some ({ id := 7, email := "a@example.com", age := 20 } : UserV2) := by
  rfl

example : migrateUser missingEmailDraft = none := by
  rfl

example : migrateUser missingAgeDraft = none := by
  rfl

theorem migrateUser_refactor (u : UserDraft) :
    migrateUser u = migrateUserDo u := by
  cases u with
  | mk id emailOpt ageOpt =>
      cases emailOpt <;> cases ageOpt <;> rfl

theorem migration_assoc (u : UserDraft) :
    optBind (optBind (some u) requireEmail) requireAge =
      optBind (some u) (fun u => optBind (requireEmail u) requireAge) := by
  rfl

/-! ## エラー理由を持つ Except -/

inductive MigrationError where
  | missingEmail
  | missingAge
  deriving Repr, DecidableEq

def exceptPure {ε α : Type} (a : α) : Except ε α :=
  Except.ok a

def exceptBind {ε α β : Type}
    (x : Except ε α) (f : α → Except ε β) : Except ε β :=
  match x with
  | Except.error e => Except.error e
  | Except.ok a => f a

def requireEmailE (u : UserDraft) : Except MigrationError UserWithEmail :=
  match u.emailOpt with
  | none => Except.error MigrationError.missingEmail
  | some email => Except.ok { id := u.id, email := email, ageOpt := u.ageOpt }

def requireAgeE (u : UserWithEmail) : Except MigrationError UserV2 :=
  match u.ageOpt with
  | none => Except.error MigrationError.missingAge
  | some age => Except.ok { id := u.id, email := u.email, age := age }
