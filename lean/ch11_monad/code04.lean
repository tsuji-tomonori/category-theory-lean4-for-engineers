-- 出典: chapters/ch11_monad.tex:224
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter11Monad

def optPure {α : Type} (a : α) : Option α :=
  some a

def optBind {α β : Type} (x : Option α) (f : α → Option β) : Option β :=
  match x with
  | none => none
  | some a => f a

#eval optBind (some 10) (fun n => some (n + 1))
#eval optBind (none : Option Nat) (fun n => some (n + 1))

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
