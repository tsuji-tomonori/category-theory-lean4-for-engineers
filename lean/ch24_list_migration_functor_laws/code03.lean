-- Source: chapters/ch24_list_migration_functor_laws.tex:234

theorem list_map_id {A : Type} (xs : List A) :
    xs.map (fun x => x) = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [ih]

theorem list_map_comp {A B C : Type}
    (f : A -> B) (g : B -> C) (xs : List A) :
    xs.map (fun x => g (f x)) = (xs.map f).map g := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [ih]
