/-
第23章 ケーススタディ：lossy migration と仕様弱化
Lean 4 examples.

このファイルは標準 Lean 4 だけで読めることを意図した、
章本文用の小さな検証モデルです。
-/

namespace Ch23

/-- 旧形式の `fullName` を、Lean上では分解済みの小さなモデルで表す。 -/
structure FullName where
  first : String
  middle : Option String
  last : String
deriving Repr, DecidableEq

/-- 旧スキーマ。実務上は `fullName : String` として保存されていたと読む。 -/
structure UserV1 where
  id : Nat
  fullName : FullName
deriving Repr, DecidableEq

/-- 新スキーマ。ミドルネームを置く場所はない。 -/
structure UserV2 where
  id : Nat
  firstName : String
  lastName : String
deriving Repr, DecidableEq

/-- 移行。新スキーマに入らない `middle` は落ちる。 -/
def migrate (u : UserV1) : UserV2 :=
  { id := u.id,
    firstName := u.fullName.first,
    lastName := u.fullName.last }

/-- 逆向き変換。戻すときは `middle = none` として埋めるしかない。 -/
def rollback (v : UserV2) : UserV1 :=
  { id := v.id,
    fullName :=
      { first := v.firstName,
        middle := none,
        last := v.lastName } }

/-- 新形式から旧形式へ戻し、再び新形式へ移す方向は常に戻る。 -/
theorem new_round_trip (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk id firstName lastName =>
      rfl

/-- ミドルネームを含む旧データ。 -/
def oldWithMiddle : UserV1 :=
  { id := 42,
    fullName :=
      { first := "Ada",
        middle := some "Byron",
        last := "Lovelace" } }

#eval migrate oldWithMiddle
#eval rollback (migrate oldWithMiddle)

/-- この具体例では、旧データへ完全には戻らない。 -/
theorem oldWithMiddle_not_restored :
    rollback (migrate oldWithMiddle) ≠ oldWithMiddle := by
  decide

/-- 強い仕様：すべての旧データについて完全に戻る。 -/
def StrongRoundTrip : Prop :=
  ∀ u : UserV1, rollback (migrate u) = u

/-- 強い仕様は、この移行では成り立たない。 -/
theorem strong_spec_fails : ¬ StrongRoundTrip := by
  intro h
  exact oldWithMiddle_not_restored (h oldWithMiddle)

/-- 旧データを公開表示用に正規化する。ミドルネームは表示しない方針にする。 -/
def canonicalDisplayV1 (u : UserV1) : String :=
  u.fullName.first ++ " " ++ u.fullName.last

/-- 新データの表示。 -/
def displayV2 (v : UserV2) : String :=
  v.firstName ++ " " ++ v.lastName

/-- 弱い仕様：完全復元ではなく、公開表示が一致することだけを要求する。 -/
def WeakDisplaySpec : Prop :=
  ∀ u : UserV1, displayV2 (migrate u) = canonicalDisplayV1 u

/-- 弱い仕様は全旧データについて成り立つ。 -/
theorem weak_display_spec_holds : WeakDisplaySpec := by
  intro u
  rfl

/-- well-formed 条件。このモデルでは「ミドルネームがない」こと。 -/
def NoMiddle (u : UserV1) : Prop :=
  u.fullName.middle = none

/-- 条件付き仕様：well-formed な旧データなら完全に戻る。 -/
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

/-- 正規化。旧データを、新形式で表せる範囲の旧データへ丸める。 -/
def normalizeV1 (u : UserV1) : UserV1 :=
  rollback (migrate u)

/-- 正規化してから移行しても、最初に移行した結果と同じ。 -/
theorem migrate_after_normalize (u : UserV1) :
    migrate (normalizeV1 u) = migrate u := by
  cases u with
  | mk id fullName =>
      cases fullName with
      | mk first middle last =>
          rfl

/-- 正規化は一度で十分。二度かけても結果は変わらない。 -/
theorem normalize_idempotent (u : UserV1) :
    normalizeV1 (normalizeV1 u) = normalizeV1 u := by
  cases u with
  | mk id fullName =>
      cases fullName with
      | mk first middle last =>
          rfl

end Ch23
