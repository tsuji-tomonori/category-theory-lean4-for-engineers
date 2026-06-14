-- Source: chapters/ch26_db_schema_query_preservation.tex:152

/-
第26章 ケーススタディ：DB スキーマ変更とクエリ保存

Mathlib には依存しない、Lean 4 標準機能だけの小さなモデル。
旧スキーマの注文行を、ユーザー行と注文行に分割し、
表示用クエリの結果が移行前後で一致することを証明する。
-/

namespace Ch26

structure OrderOld where
  orderId : Nat
  userId : Nat
  userName : String
  amount : Nat

deriving Repr, DecidableEq

structure UserRow where
  userId : Nat
  userName : String

deriving Repr, DecidableEq

structure OrderRow where
  orderId : Nat
  userId : Nat
  amount : Nat

deriving Repr, DecidableEq

structure SplitRow where
  user : UserRow
  order : OrderRow

deriving Repr, DecidableEq

structure OrderView where
  orderId : Nat
  userName : String
  amount : Nat

deriving Repr, DecidableEq
