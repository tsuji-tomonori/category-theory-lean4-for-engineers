-- Source: chapters/ch26_db_schema_query_preservation.tex:245

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
