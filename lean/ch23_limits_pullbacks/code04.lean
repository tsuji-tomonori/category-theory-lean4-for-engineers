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

def toProfileOrder {X : Type}
    (f : X -> Profile) (g : X -> Order)
    (h : forall x, (f x).userId = (g x).userId) :
    X -> ProfileOrder :=
  fun x =>
    { profile := f x, order := g x, consistent := h x }

theorem toProfileOrder_profile {X : Type}
    (f : X -> Profile) (g : X -> Order)
    (h : forall x, (f x).userId = (g x).userId)
    (x : X) :
    (toProfileOrder f g h x).profile = f x := rfl

theorem toProfileOrder_order {X : Type}
    (f : X -> Profile) (g : X -> Order)
    (h : forall x, (f x).userId = (g x).userId)
    (x : X) :
    (toProfileOrder f g h x).order = g x := rfl

theorem toProfileOrder_unique {X : Type}
    (f : X -> Profile) (g : X -> Order)
    (h : forall x, (f x).userId = (g x).userId)
    (k : X -> ProfileOrder)
    (hp : forall x, (k x).profile = f x)
    (ho : forall x, (k x).order = g x) :
    k = toProfileOrder f g h := by
  funext x
  cases hx : k x with
  | mk p o consistent =>
      have hp' : p = f x := by simpa [hx] using hp x
      have ho' : o = g x := by simpa [hx] using ho x
      subst p
      subst o
      rfl

theorem toProfileOrder_consistent {X : Type}
    (f : X -> Profile) (g : X -> Order)
    (h : forall x, (f x).userId = (g x).userId)
    (x : X) :
    (toProfileOrder f g h x).profile.userId =
      (toProfileOrder f g h x).order.userId :=
  h x

def upgradeOrder (o : Order) : Order :=
  { o with total := o.total + 1 }

theorem upgradeOrder_preserves_userId (o : Order) :
    (upgradeOrder o).userId = o.userId := rfl

def liftJoinedOrder (j : ProfileOrder) : ProfileOrder :=
  { profile := j.profile,
    order := upgradeOrder j.order,
    consistent := by
      simpa [upgradeOrder] using j.consistent }

theorem liftJoinedOrder_preserves_profile
    (j : ProfileOrder) :
    (liftJoinedOrder j).profile = j.profile := rfl

theorem liftJoinedOrder_preserves_consistency
    (j : ProfileOrder) :
    (liftJoinedOrder j).profile.userId =
      (liftJoinedOrder j).order.userId :=
  (liftJoinedOrder j).consistent
