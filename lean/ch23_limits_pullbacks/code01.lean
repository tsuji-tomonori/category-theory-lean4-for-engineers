-- 出典: chapters/ch17_limits_pullbacks.tex:156
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch17

abbrev UserId := Nat

structure Profile where
  userId : UserId
  displayName : String
deriving Repr, DecidableEq

structure Order where
  orderId : Nat
  userId : UserId
  total : Nat
deriving Repr, DecidableEq

structure ProfileOrder where
  profile : Profile
  order : Order
  consistent : profile.userId = order.userId
