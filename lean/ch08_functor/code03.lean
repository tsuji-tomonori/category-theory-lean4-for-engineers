-- Source: chapters/ch08_functor.tex:189

-- List.map は合成を保存する。
theorem list_map_comp {A B C : Type}
    (f : A -> B) (g : B -> C) (xs : List A) :
    List.map g (List.map f xs) =
      List.map (fun x => g (f x)) xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]
