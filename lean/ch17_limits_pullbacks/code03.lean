-- Source: chapters/ch17_limits_pullbacks.tex:214

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
