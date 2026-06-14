-- Source: chapters/ch09_natural_transformation.tex:348

/-- Map business logic inside the old wrapper. -/
def oldMap {A B : Type} (f : A -> B)
    (r : OldResponse A) : OldResponse B :=
  { traceId := r.traceId,
    payload := optionMap f r.payload }

/-- Map business logic inside the new wrapper. -/
def newMap {A B : Type} (f : A -> B)
    (r : NewResponse A) : NewResponse B :=
  { traceId := r.traceId,
    status := r.status,
    items := List.map f r.items }

/-- Adapter from the old wrapper to the new wrapper. -/
def adapt {A : Type} (r : OldResponse A) : NewResponse A :=
  { traceId := r.traceId,
    status := statusOf r.payload,
    items := optionToList r.payload }

#eval adapt ({ traceId := 7, payload := some 42 } : OldResponse Nat)
