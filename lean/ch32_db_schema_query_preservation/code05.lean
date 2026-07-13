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

def Consistent (s : SplitRow) : Prop :=
  s.user.userId = s.order.userId

def ConsistentSplitRow := { s : SplitRow // Consistent s }

theorem split_consistent (r : OrderOld) :
    Consistent (splitOrder r) := by
  cases r
  rfl

def splitOrderChecked (r : OrderOld) : ConsistentSplitRow :=
  Subtype.mk (splitOrder r) (split_consistent r)

def queryNewRow (s : ConsistentSplitRow) : OrderView :=
  { orderId := s.val.order.orderId,
    userName := s.val.user.userName,
    amount := s.val.order.amount }

def DBV1 := List OrderOld

def DBV2 := List ConsistentSplitRow

def migrateDB (db : DBV1) : DBV2 :=
  List.map splitOrderChecked db

def queryOld (db : DBV1) : List OrderView :=
  List.map queryOldRow db

def queryNew (db : DBV2) : List OrderView :=
  List.map queryNewRow db

theorem checked_row_preserves_query (r : OrderOld) :
    queryNewRow (splitOrderChecked r) = queryOldRow r := by
  cases r
  rfl

theorem query_preserved (db : DBV1) :
    queryNew (migrateDB db) = queryOld db := by
  induction db with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateDB, queryNew, queryOld,
            checked_row_preserves_query]

def sampleOld : DBV1 :=
  [ { orderId := 1001, userId := 10,
      userName := "Ada", amount := 120 },
    { orderId := 1002, userId := 20,
      userName := "Grace", amount := 250 } ]

#eval queryOld sampleOld
#eval queryNew (migrateDB sampleOld)

end Chapter32
