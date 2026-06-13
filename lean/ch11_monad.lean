/-
第11章 モナド：失敗・状態・非同期を合成する形
このファイルは本文中の Lean コードを抜き出したものです。
Mathlib の CategoryTheory API は使わず、標準的な Lean 4 の構文と小さな自作定義だけで説明します。
-/

namespace Chapter11Monad

/-! ## Option の pure と bind -/

def optPure {α : Type} (a : α) : Option α :=
  some a

def optBind {α β : Type} (x : Option α) (f : α → Option β) : Option β :=
  match x with
  | none => none
  | some a => f a

#eval optBind (some 10) (fun n => some (n + 1))
#eval optBind (none : Option Nat) (fun n => some (n + 1))

/-! ## Option のモナド則 -/

theorem option_left_identity {α β : Type} (a : α) (f : α → Option β) :
    optBind (optPure a) f = f a := by
  rfl

theorem option_right_identity {α : Type} (x : Option α) :
    optBind x optPure = x := by
  cases x <;> rfl

theorem option_assoc {α β γ : Type}
    (x : Option α) (f : α → Option β) (g : β → Option γ) :
    optBind (optBind x f) g =
      optBind x (fun a => optBind (f a) g) := by
  cases x <;> rfl

/-! ## 失敗しうるユーザー移行 -/

structure UserDraft where
  id : Nat
  emailOpt : Option String
  ageOpt : Option Nat
  deriving Repr, DecidableEq

structure UserWithEmail where
  id : Nat
  email : String
  ageOpt : Option Nat
  deriving Repr, DecidableEq

structure UserV2 where
  id : Nat
  email : String
  age : Nat
  deriving Repr, DecidableEq

def requireEmail (u : UserDraft) : Option UserWithEmail :=
  match u.emailOpt with
  | none => none
  | some email => some { id := u.id, email := email, ageOpt := u.ageOpt }

def requireAge (u : UserWithEmail) : Option UserV2 :=
  match u.ageOpt with
  | none => none
  | some age => some { id := u.id, email := u.email, age := age }

def migrateUser (u : UserDraft) : Option UserV2 :=
  optBind (requireEmail u) requireAge

def migrateUserDo (u : UserDraft) : Option UserV2 := do
  let withEmail ← requireEmail u
  requireAge withEmail

def goodDraft : UserDraft :=
  { id := 7, emailOpt := some "a@example.com", ageOpt := some 20 }

def missingEmailDraft : UserDraft :=
  { id := 8, emailOpt := none, ageOpt := some 20 }

def missingAgeDraft : UserDraft :=
  { id := 9, emailOpt := some "b@example.com", ageOpt := none }

#eval migrateUser goodDraft
#eval migrateUser missingEmailDraft
#eval migrateUser missingAgeDraft

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

def migrateUserExcept (u : UserDraft) : Except MigrationError UserV2 :=
  exceptBind (requireEmailE u) requireAgeE

#eval migrateUserExcept goodDraft
#eval migrateUserExcept missingEmailDraft
#eval migrateUserExcept missingAgeDraft

theorem except_left_identity {ε α β : Type} (a : α) (f : α → Except ε β) :
    exceptBind (exceptPure a) f = f a := by
  rfl

theorem except_right_identity {ε α : Type} (x : Except ε α) :
    exceptBind x exceptPure = x := by
  cases x <;> rfl

theorem except_assoc {ε α β γ : Type}
    (x : Except ε α) (f : α → Except ε β) (g : β → Except ε γ) :
    exceptBind (exceptBind x f) g =
      exceptBind x (fun a => exceptBind (f a) g) := by
  cases x <;> rfl

/-! ## 状態を持つ計算の最小モデル -/

abbrev SimpleState (σ α : Type) := σ → (α × σ)

def statePure {σ α : Type} (a : α) : SimpleState σ α :=
  fun s => (a, s)

def stateBind {σ α β : Type}
    (m : SimpleState σ α) (f : α → SimpleState σ β) : SimpleState σ β :=
  fun s =>
    let r := m s
    f r.fst r.snd

def getState : SimpleState Nat Nat :=
  fun s => (s, s)

def putState (s : Nat) : SimpleState Nat Unit :=
  fun _ => ((), s)

def tick : SimpleState Nat Nat :=
  stateBind getState (fun n =>
    stateBind (putState (n + 1)) (fun _ =>
      statePure n))

def twoTicks : SimpleState Nat (Nat × Nat) :=
  stateBind tick (fun first =>
    stateBind tick (fun second =>
      statePure (first, second)))

#eval tick 10
#eval twoTicks 10

theorem state_left_identity_pointwise {σ α β : Type}
    (a : α) (f : α → SimpleState σ β) (s : σ) :
    stateBind (statePure a) f s = f a s := by
  rfl

end Chapter11Monad
