-- Source: chapters/ch25_api_adapter_naturality.tex:105

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
