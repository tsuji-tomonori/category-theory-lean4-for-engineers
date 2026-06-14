-- Source: chapters/ch17_limits_pullbacks.tex:186

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
