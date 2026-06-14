-- Source: chapters/ch25_api_adapter_naturality.tex:146

end NewResponse

/-- Adapter from the old response shape to the new response shape. -/
def adapt {A : Type} (r : OldResponse A) : NewResponse A :=
  { code := r.status,
    data := r.body,
    requestId := r.requestId,
    cached := false }
