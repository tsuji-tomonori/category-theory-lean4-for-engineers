-- Source: chapters/ch25_api_adapter_naturality.tex:283

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
