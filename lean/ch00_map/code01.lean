-- Source: chapters/ch00_map.tex:219

/-
第0章「仕様・変更・証明の地図」で掲載する Lean 4 コードの予告例。

この章では本格的な Lean 入門には入らない。
目的は、後続章で扱う「移行関数」と「round-trip 性質」の形を先に眺めること。
-/

structure UserV1 where
  id : Nat
  name : String

deriving instance Repr for UserV1

structure UserV2 where
  id : Nat
  profileName : String

deriving instance Repr for UserV2

def migrate (u : UserV1) : UserV2 :=
  { id := u.id, profileName := u.name }

def rollback (v : UserV2) : UserV1 :=
  { id := v.id, name := v.profileName }

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v
  rfl
