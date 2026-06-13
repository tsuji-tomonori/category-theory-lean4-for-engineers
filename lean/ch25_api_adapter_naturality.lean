/-
Chapter 25: API adapter and naturality.
This file intentionally avoids Mathlib's CategoryTheory API.
It models only the small part needed for the chapter.
-/

namespace Chapter25

/-- Old API response wrapper. -/
structure OldResponse (A : Type) where
  status : Nat
  body : Option A
  requestId : String

/-- New API response wrapper. -/
structure NewResponse (A : Type) where
  code : Nat
  data : Option A
  requestId : String
  cached : Bool

namespace OldResponse

/-- Apply business logic only to the payload. -/
def map {A B : Type} (f : A -> B) (r : OldResponse A) : OldResponse B :=
  { status := r.status,
    body := Option.map f r.body,
    requestId := r.requestId }

end OldResponse

namespace NewResponse

/-- Apply business logic only to the payload. -/
def map {A B : Type} (f : A -> B) (r : NewResponse A) : NewResponse B :=
  { code := r.code,
    data := Option.map f r.data,
    requestId := r.requestId,
    cached := r.cached }

end NewResponse

/-- Adapter from the old response shape to the new response shape. -/
def adapt {A : Type} (r : OldResponse A) : NewResponse A :=
  { code := r.status,
    data := r.body,
    requestId := r.requestId,
    cached := false }

/-- The old response map preserves identity. -/
theorem old_map_id {A : Type} (r : OldResponse A) :
    OldResponse.map (fun x => x) r = r := by
  cases r with
  | mk status body requestId =>
    cases body <;> rfl

/-- The new response map preserves identity. -/
theorem new_map_id {A : Type} (r : NewResponse A) :
    NewResponse.map (fun x => x) r = r := by
  cases r with
  | mk code data requestId cached =>
    cases data <;> rfl

/-- The old response map preserves composition. -/
theorem old_map_comp {A B C : Type} (g : B -> C) (f : A -> B)
    (r : OldResponse A) :
    OldResponse.map (fun x => g (f x)) r =
      OldResponse.map g (OldResponse.map f r) := by
  cases r with
  | mk status body requestId =>
    cases body <;> rfl

/-- The new response map preserves composition. -/
theorem new_map_comp {A B C : Type} (g : B -> C) (f : A -> B)
    (r : NewResponse A) :
    NewResponse.map (fun x => g (f x)) r =
      NewResponse.map g (NewResponse.map f r) := by
  cases r with
  | mk code data requestId cached =>
    cases data <;> rfl

/-- Naturality: adapting commutes with applying business logic to the payload. -/
theorem adapt_natural {A B : Type} (f : A -> B) (r : OldResponse A) :
    adapt (OldResponse.map f r) = NewResponse.map f (adapt r) := by
  cases r
  rfl

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

/-- A small packaged form of naturality for this specific adapter type. -/
structure ResponseAdapter where
  app : {A : Type} -> OldResponse A -> NewResponse A
  naturality : {A B : Type} -> (f : A -> B) -> (r : OldResponse A) ->
    app (OldResponse.map f r) = NewResponse.map f (app r)

/-- The adapter above, packaged with its proof. -/
def oldToNewAdapter : ResponseAdapter where
  app := fun {A} r => adapt (A := A) r
  naturality := by
    intro A B f r
    exact adapt_natural f r

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
