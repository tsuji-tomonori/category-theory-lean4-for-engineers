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

/-- 旧注文行を、ユーザー部分と注文部分に分割する。 -/
def splitOrder (r : OrderOld) : SplitRow :=
  { user := { userId := r.userId, userName := r.userName },
    order := { orderId := r.orderId,
               userId := r.userId,
               amount := r.amount } }

/-- 旧スキーマから表示用ビューを作るクエリ。 -/
def queryOldRow (r : OrderOld) : OrderView :=
  { orderId := r.orderId,
    userName := r.userName,
    amount := r.amount }

/-- 分割済み行から表示用ビューを作るクエリ。 -/
def querySplitRow (s : SplitRow) : OrderView :=
  { orderId := s.order.orderId,
    userName := s.user.userName,
    amount := s.order.amount }

/-- 一行だけを見れば、移行してからクエリしても結果は同じ。 -/
theorem split_row_preserves_query (r : OrderOld) :
    querySplitRow (splitOrder r) = queryOldRow r := by
  cases r
  rfl

/-- ユーザー行と注文行の外部キーが一致している、という整合条件。 -/
def Consistent (s : SplitRow) : Prop :=
  s.user.userId = s.order.userId

/-- 整合条件の証明を持つ分割行。 -/
def ConsistentSplitRow := { s : SplitRow // Consistent s }

/-- 旧行から作った分割行は、必ず userId の整合条件を満たす。 -/
theorem split_consistent (r : OrderOld) :
    Consistent (splitOrder r) := by
  cases r
  rfl

/-- 整合性の証明を添えて、旧行を新スキーマ行へ移す。 -/
def splitOrderChecked (r : OrderOld) : ConsistentSplitRow :=
  Subtype.mk (splitOrder r) (split_consistent r)

/-- 整合済みの新スキーマ行から表示用ビューを作る。 -/
def queryNewRow (s : ConsistentSplitRow) : OrderView :=
  { orderId := s.val.order.orderId,
    userName := s.val.user.userName,
    amount := s.val.order.amount }

/-- 本章の有限 DB モデル。 -/
def DBV1 := List OrderOld

def DBV2 := List ConsistentSplitRow

/-- DB 全体を新スキーマへ移す。 -/
def migrateDB (db : DBV1) : DBV2 :=
  List.map splitOrderChecked db

/-- 旧 DB へのクエリ。 -/
def queryOld (db : DBV1) : List OrderView :=
  List.map queryOldRow db

/-- 新 DB へのクエリ。 -/
def queryNew (db : DBV2) : List OrderView :=
  List.map queryNewRow db

/-- 整合性つきにしても、一行のクエリ保存は成り立つ。 -/
theorem checked_row_preserves_query (r : OrderOld) :
    queryNewRow (splitOrderChecked r) = queryOldRow r := by
  cases r
  rfl

/--
任意の旧 DB について、移行後に新クエリを実行した結果は、
移行前に旧クエリを実行した結果と一致する。
-/
theorem query_preserved (db : DBV1) :
    queryNew (migrateDB db) = queryOld db := by
  induction db with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateDB, queryNew, queryOld,
            checked_row_preserves_query, ih]

/-- 読み取り用の小さなサンプル。 -/
def sampleOld : DBV1 :=
  [ { orderId := 1001, userId := 10,
      userName := "Ada", amount := 120 },
    { orderId := 1002, userId := 20,
      userName := "Grace", amount := 250 } ]

#eval queryOld sampleOld
#eval queryNew (migrateDB sampleOld)

end Ch26
