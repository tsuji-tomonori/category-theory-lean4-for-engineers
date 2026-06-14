-- 出典: chapters/ch06_isomorphism.tex:253
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch06

universe u v

structure Iso (A : Type u) (B : Type v) where
  toFun : A → B
  invFun : B → A
  left_inv : ∀ a : A, invFun (toFun a) = a
  right_inv : ∀ b : B, toFun (invFun b) = b

namespace Iso

def refl (A : Type u) : Iso A A where
  toFun := fun a => a
  invFun := fun a => a
  left_inv := by
    intro a
    rfl
  right_inv := by
    intro a
    rfl

def symm {A : Type u} {B : Type v} (e : Iso A B) : Iso B A where
  toFun := e.invFun
  invFun := e.toFun
  left_inv := e.right_inv
  right_inv := e.left_inv

end Iso

structure UserV1 where
  id : Nat
  email : String
  displayName : String
deriving Repr, DecidableEq

structure Contact where
  email : String
deriving Repr, DecidableEq

structure Profile where
  displayName : String
deriving Repr, DecidableEq

structure UserV2 where
  userId : Nat
  contact : Contact
  profile : Profile
deriving Repr, DecidableEq

def migrate (u : UserV1) : UserV2 :=
  { userId := u.id
    contact := { email := u.email }
    profile := { displayName := u.displayName } }

def rollback (v : UserV2) : UserV1 :=
  { id := v.userId
    email := v.contact.email
    displayName := v.profile.displayName }

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk userId contact profile =>
    cases contact with
    | mk email =>
      cases profile with
      | mk displayName =>
        rfl

def userIso : Iso UserV1 UserV2 where
  toFun := migrate
  invFun := rollback
  left_inv := rollback_migrate
  right_inv := migrate_rollback

def eraseToUnit (_ : UserV1) : Unit := ()

def defaultUser (_ : Unit) : UserV1 :=
  { id := 0, email := "", displayName := "" }

def sampleUser : UserV1 :=
  { id := 1, email := "alice@example.com", displayName := "Alice" }

example : defaultUser (eraseToUnit sampleUser) ≠ sampleUser := by
  decide

#eval migrate sampleUser
#eval rollback (migrate sampleUser)

end Ch06
