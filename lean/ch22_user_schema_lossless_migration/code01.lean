-- Source: chapters/ch22_user_schema_lossless_migration.tex:129

/-
第22章 ケーススタディ：User スキーマの lossless migration

このファイルは、本文中の Lean コードを抽出したものです。
標準ライブラリだけで読める小さなモデルとして書いています。
-/

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
