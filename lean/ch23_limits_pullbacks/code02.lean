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

def joinProfileOrder (p : Profile) (o : Order)
    (h : p.userId = o.userId) : ProfileOrder :=
  { profile := p, order := o, consistent := h }

theorem joined_profile_id_eq_order_id
    (j : ProfileOrder) : j.profile.userId = j.order.userId :=
  j.consistent

def orderToUserId (o : Order) : UserId := o.userId

def profileToUserId (p : Profile) : UserId := p.userId

theorem pullback_square_commutes (j : ProfileOrder) :
    profileToUserId j.profile = orderToUserId j.order :=
  j.consistent
