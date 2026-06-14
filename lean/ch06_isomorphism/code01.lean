-- Source: chapters/ch06_isomorphism.tex:105

/-
第6章 同型：安全な相互変換

このファイルは、chapters/ch06_isomorphism.tex に掲載したLeanコードを
章単体で読みやすい形にまとめたものです。
MathlibのCategoryTheory APIは使わず、Lean 4の標準的な構文だけで
「二つの関数 + 二つのround-trip証明」として同型を表します。
-/

namespace Ch06

universe u v

/-- 型 A と型 B の間の小さな同型構造。 -/
structure Iso (A : Type u) (B : Type v) where
  toFun : A → B
  invFun : B → A
  left_inv : ∀ a : A, invFun (toFun a) = a
  right_inv : ∀ b : B, toFun (invFun b) = b

namespace Iso

/-- 同じ型は自明に同型である。 -/
def refl (A : Type u) : Iso A A where
  toFun := fun a => a
  invFun := fun a => a
  left_inv := by
    intro a
    rfl
  right_inv := by
    intro a
    rfl

/-- 同型は向きを反転できる。 -/
def symm {A : Type u} {B : Type v} (e : Iso A B) : Iso B A where
  toFun := e.invFun
  invFun := e.toFun
  left_inv := e.right_inv
  right_inv := e.left_inv

end Iso

/-- 旧ユーザー型。 -/
structure UserV1 where
  id : Nat
  email : String
  displayName : String
deriving Repr, DecidableEq

/-- 連絡先を分離した新形式の一部。 -/
structure Contact where
  email : String
deriving Repr, DecidableEq

/-- プロフィールを分離した新形式の一部。 -/
structure Profile where
  displayName : String
deriving Repr, DecidableEq

/-- 新ユーザー型。 -/
structure UserV2 where
  userId : Nat
  contact : Contact
  profile : Profile
deriving Repr, DecidableEq

/-- 旧形式から新形式への移行。 -/
def migrate (u : UserV1) : UserV2 :=
  { userId := u.id
    contact := { email := u.email }
    profile := { displayName := u.displayName } }

/-- 新形式から旧形式へのロールバック。 -/
def rollback (v : UserV2) : UserV1 :=
  { id := v.userId
    email := v.contact.email
    displayName := v.profile.displayName }

/-- 旧形式から移行して戻すと、旧形式が復元される。 -/
theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

/-- 新形式から戻して再移行すると、新形式が復元される。 -/
theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk userId contact profile =>
    cases contact with
    | mk email =>
      cases profile with
      | mk displayName =>
        rfl

/-- UserV1 と UserV2 は情報を失わずに相互変換できる。 -/
def userIso : Iso UserV1 UserV2 where
  toFun := migrate
  invFun := rollback
  left_inv := rollback_migrate
  right_inv := migrate_rollback

/-- 双方向の関数があっても、情報を捨てれば同型ではない。 -/
def eraseToUnit (_ : UserV1) : Unit := ()

/-- Unit からは、元のユーザー情報を復元できないのでデフォルト値を返す。 -/
def defaultUser (_ : Unit) : UserV1 :=
  { id := 0, email := "", displayName := "" }

/-- 具体例。 -/
def sampleUser : UserV1 :=
  { id := 1, email := "alice@example.com", displayName := "Alice" }

/-- eraseToUnit してから defaultUser で戻しても、元の値には戻らない。 -/
example : defaultUser (eraseToUnit sampleUser) ≠ sampleUser := by
  decide


#eval migrate sampleUser
#eval rollback (migrate sampleUser)

end Ch06
