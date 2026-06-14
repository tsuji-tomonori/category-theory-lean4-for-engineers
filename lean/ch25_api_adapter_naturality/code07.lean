-- Source: chapters/ch25_api_adapter_naturality.tex:318

/-- Any packaged natural adapter gives the same commutation law. -/
theorem adapter_commutes (ad : ResponseAdapter) {A B : Type}
    (f : A -> B) (r : OldResponse A) :
    ad.app (OldResponse.map f r) = NewResponse.map f (ad.app r) := by
  exact ad.naturality f r

/-- Concrete payload used in the running API example. -/
structure UserV1 where
  id : Nat
  name : String

/-- Smaller payload returned to a public client. -/
structure UserView where
  id : Nat

/-- Business logic that forgets the internal name. -/
def toUserView (u : UserV1) : UserView :=
  { id := u.id }

/-- Naturality specialized to the user example. -/
theorem user_view_adapter_position_independent (r : OldResponse UserV1) :
    routeBefore toUserView r = routeAfter toUserView r := by
  exact route_position_independent toUserView r


/-- Metadata preservation is independent of the payload type. -/
theorem adapt_preserves_status {A : Type} (r : OldResponse A) :
    (adapt r).code = r.status := by
  rfl

/-- The request ID is copied by the adapter. -/
theorem adapt_preserves_requestId {A : Type} (r : OldResponse A) :
    (adapt r).requestId = r.requestId := by
  rfl

/-- The new cache flag is explicitly initialized. -/
theorem adapt_sets_cached_false {A : Type} (r : OldResponse A) :
    (adapt r).cached = false := by
  rfl

end Chapter25
