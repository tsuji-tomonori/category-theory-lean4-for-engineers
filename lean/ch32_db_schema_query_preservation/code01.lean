-- 出典: chapters/ch32_db_schema_query_preservation.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter32

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
