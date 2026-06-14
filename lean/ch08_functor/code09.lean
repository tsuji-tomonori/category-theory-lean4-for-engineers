-- Source: chapters/ch08_functor.tex:352

-- List.map はリストの長さを保存する。
theorem list_map_length {A B : Type}
    (f : A -> B) (xs : List A) :
    (List.map f xs).length = xs.length := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

theorem migrateUsers_length (users : List UserV1) :
    (migrateUsers users).length = users.length := by
  exact list_map_length migrateUser users
