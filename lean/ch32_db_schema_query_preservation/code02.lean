-- 出典: chapters/ch26_db_schema_query_preservation.tex:202
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

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

def splitOrder (r : OrderOld) : SplitRow :=
  { user := { userId := r.userId, userName := r.userName },
    order := { orderId := r.orderId,
               userId := r.userId,
               amount := r.amount } }

def queryOldRow (r : OrderOld) : OrderView :=
  { orderId := r.orderId,
    userName := r.userName,
    amount := r.amount }

def querySplitRow (s : SplitRow) : OrderView :=
  { orderId := s.order.orderId,
    userName := s.user.userName,
    amount := s.order.amount }

theorem split_row_preserves_query (r : OrderOld) :
    querySplitRow (splitOrder r) = queryOldRow r := by
  cases r
  rfl
