-- Source: chapters/ch27_composable_design.tex:149

end Ch27

namespace Ch27ETL

structure RawRow where
  userId : Nat
  amountText : Nat
  deriving Repr, DecidableEq

structure ValidRow where
  userId : Nat
  amount : Nat
  deriving Repr, DecidableEq

structure EnrichedRow where
  userId : Nat
  amount : Nat
  fee : Nat
  deriving Repr, DecidableEq

structure ReportRow where
  userId : Nat
  total : Nat
  deriving Repr, DecidableEq
