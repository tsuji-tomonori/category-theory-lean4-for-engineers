-- Source: chapters/ch25_api_adapter_naturality.tex:226

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
