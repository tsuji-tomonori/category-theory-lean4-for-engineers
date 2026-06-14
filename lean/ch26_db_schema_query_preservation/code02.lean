-- Source: chapters/ch26_db_schema_query_preservation.tex:202

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
