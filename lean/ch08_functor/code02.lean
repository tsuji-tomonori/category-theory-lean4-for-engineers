-- Source: chapters/ch08_functor.tex:146

-- List.map は恒等関数を保存する。
theorem list_map_id {A : Type} (xs : List A) :
    List.map (fun x => x) xs = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]
