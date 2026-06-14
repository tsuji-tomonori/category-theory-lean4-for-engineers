-- Source: chapters/ch15_function_extensionality.tex:329

def clientWithFallback
    (client : Request → Option Response) : Request → Option Response :=
  fun r =>
    match client r with
    | some res => some res
    | none => none

theorem clientWithFallback_eq
    (client : Request → Option Response) :
    clientWithFallback client = client := by
  funext r
  cases h : client r <;> simp [clientWithFallback, h]


end Ch15
