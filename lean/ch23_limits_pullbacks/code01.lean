-- 出典: chapters/ch23_limits_pullbacks.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter23

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
