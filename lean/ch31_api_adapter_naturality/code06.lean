-- 出典: chapters/ch31_api_adapter_naturality.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter31

structure OldResponse (A : Type) where
  status : Nat
  body : Option A
  requestId : String

structure NewResponse (A : Type) where
  code : Nat
  data : Option A
  requestId : String
  cached : Bool

namespace OldResponse

def map {A B : Type} (f : A -> B) (r : OldResponse A) : OldResponse B :=
  { status := r.status,
    body := Option.map f r.body,
    requestId := r.requestId }

end OldResponse

namespace NewResponse

def map {A B : Type} (f : A -> B) (r : NewResponse A) : NewResponse B :=
  { code := r.code,
    data := Option.map f r.data,
    requestId := r.requestId,
    cached := r.cached }

end NewResponse

def adapt {A : Type} (r : OldResponse A) : NewResponse A :=
  { code := r.status,
    data := r.body,
    requestId := r.requestId,
    cached := false }

theorem old_map_id {A : Type} (r : OldResponse A) :
    OldResponse.map (fun x => x) r = r := by
  cases r with
  | mk status body requestId =>
    cases body <;> rfl

theorem new_map_id {A : Type} (r : NewResponse A) :
    NewResponse.map (fun x => x) r = r := by
  cases r with
  | mk code data requestId cached =>
    cases data <;> rfl

theorem old_map_comp {A B C : Type} (g : B -> C) (f : A -> B)
    (r : OldResponse A) :
    OldResponse.map (fun x => g (f x)) r =
      OldResponse.map g (OldResponse.map f r) := by
  cases r with
  | mk status body requestId =>
    cases body <;> rfl

theorem new_map_comp {A B C : Type} (g : B -> C) (f : A -> B)
    (r : NewResponse A) :
    NewResponse.map (fun x => g (f x)) r =
      NewResponse.map g (NewResponse.map f r) := by
  cases r with
  | mk code data requestId cached =>
    cases data <;> rfl

theorem adapt_natural {A B : Type} (f : A -> B) (r : OldResponse A) :
    adapt (OldResponse.map f r) = NewResponse.map f (adapt r) := by
  cases r
  rfl

def routeBefore {A B : Type} (f : A -> B) (r : OldResponse A) : NewResponse B :=
  adapt (OldResponse.map f r)

def routeAfter {A B : Type} (f : A -> B) (r : OldResponse A) : NewResponse B :=
  NewResponse.map f (adapt r)

theorem route_position_independent {A B : Type} (f : A -> B)
    (r : OldResponse A) :
    routeBefore f r = routeAfter f r := by
  exact adapt_natural f r

structure ResponseAdapter where
  app : {A : Type} -> OldResponse A -> NewResponse A
  naturality : {A B : Type} -> (f : A -> B) -> (r : OldResponse A) ->
    app (OldResponse.map f r) = NewResponse.map f (app r)

def oldToNewAdapter : ResponseAdapter where
  app := fun {A} r => adapt (A := A) r
  naturality := by
    intro A B f r
    exact adapt_natural f r
