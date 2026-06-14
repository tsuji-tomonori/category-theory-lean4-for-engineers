-- Source: chapters/ch25_api_adapter_naturality.tex:255

/-- Route 1: apply business logic in the old wrapper, then adapt. -/
def routeBefore {A B : Type} (f : A -> B) (r : OldResponse A) : NewResponse B :=
  adapt (OldResponse.map f r)

/-- Route 2: adapt first, then apply business logic in the new wrapper. -/
def routeAfter {A B : Type} (f : A -> B) (r : OldResponse A) : NewResponse B :=
  NewResponse.map f (adapt r)

/-- The adapter can be placed before or after payload-only business logic. -/
theorem route_position_independent {A B : Type} (f : A -> B)
    (r : OldResponse A) :
    routeBefore f r = routeAfter f r := by
  exact adapt_natural f r
