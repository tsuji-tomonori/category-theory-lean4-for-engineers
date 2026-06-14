-- Source: chapters/ch08_functor.tex:221

-- Option.map の関手則。
theorem option_map_id {A : Type} (x : Option A) :
    Option.map (fun a => a) x = x := by
  cases x with
  | none =>
      rfl
  | some a =>
      rfl

theorem option_map_comp {A B C : Type}
    (f : A -> B) (g : B -> C) (x : Option A) :
    Option.map g (Option.map f x) =
      Option.map (fun a => g (f a)) x := by
  cases x with
  | none =>
      rfl
  | some a =>
      rfl
