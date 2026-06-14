-- Source: chapters/ch14_induction.tex:213

theorem migrateUsers_preserves_length (xs : List UserV1) :
    (migrateUsers xs).length = xs.length := by
  simpa [migrateUsers] using map_preserves_length migrateUser xs
