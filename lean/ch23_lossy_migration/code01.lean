-- Source: chapters/ch23_lossy_migration.tex:61

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
