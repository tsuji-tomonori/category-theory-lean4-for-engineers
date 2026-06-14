-- Source: chapters/ch17_limits_pullbacks.tex:251

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
