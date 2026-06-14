-- Source: chapters/ch08_functor.tex:276

-- Result.map の関手則。
theorem result_map_id {E A : Type} (x : Result E A) :
    Result.map (fun a => a) x = x := by
  cases x with
  | ok a =>
      rfl
  | error e =>
      rfl

theorem result_map_comp {E A B C : Type}
    (f : A -> B) (g : B -> C) (x : Result E A) :
    Result.map g (Result.map f x) =
      Result.map (fun a => g (f a)) x := by
  cases x with
  | ok a =>
      rfl
  | error e =>
      rfl
