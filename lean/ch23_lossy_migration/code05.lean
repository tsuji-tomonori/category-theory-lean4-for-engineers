-- 出典: chapters/ch23_lossy_migration.tex:206
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch23

structure FullName where
  first : String
  middle : Option String
  last : String
deriving Repr, DecidableEq

structure UserV1 where
  id : Nat
  fullName : FullName
deriving Repr, DecidableEq

structure UserV2 where
  id : Nat
  firstName : String
  lastName : String
deriving Repr, DecidableEq

def migrate (u : UserV1) : UserV2 :=
  { id := u.id,
    firstName := u.fullName.first,
    lastName := u.fullName.last }

def rollback (v : UserV2) : UserV1 :=
  { id := v.id,
    fullName :=
      { first := v.firstName,
        middle := none,
        last := v.lastName } }

theorem new_round_trip (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk id firstName lastName =>
      rfl

def oldWithMiddle : UserV1 :=
  { id := 42,
    fullName :=
      { first := "Ada",
        middle := some "Byron",
        last := "Lovelace" } }

#eval migrate oldWithMiddle
#eval rollback (migrate oldWithMiddle)

theorem oldWithMiddle_not_restored :
    rollback (migrate oldWithMiddle) ≠ oldWithMiddle := by
  decide

def StrongRoundTrip : Prop :=
  ∀ u : UserV1, rollback (migrate u) = u

theorem strong_spec_fails : ¬ StrongRoundTrip := by
  intro h
  exact oldWithMiddle_not_restored (h oldWithMiddle)

def canonicalDisplayV1 (u : UserV1) : String :=
  u.fullName.first ++ " " ++ u.fullName.last

def displayV2 (v : UserV2) : String :=
  v.firstName ++ " " ++ v.lastName

def WeakDisplaySpec : Prop :=
  ∀ u : UserV1, displayV2 (migrate u) = canonicalDisplayV1 u

theorem weak_display_spec_holds : WeakDisplaySpec := by
  intro u
  rfl

def NoMiddle (u : UserV1) : Prop :=
  u.fullName.middle = none

theorem rollback_after_migrate_if_no_middle
    (u : UserV1) (h : NoMiddle u) :
    rollback (migrate u) = u := by
  cases u with
  | mk id fullName =>
      cases fullName with
      | mk first middle last =>
          simp [NoMiddle] at h
          cases h
          rfl
