-- Source: chapters/ch27_composable_design.tex:269

theorem right_id (s : Stage A B) (x : A) :
    (s.andThen (id B)).run x = s.run x := by
  rfl

theorem assoc
    (s1 : Stage A B) (s2 : Stage B C) (s3 : Stage C D) (x : A) :
    ((s1.andThen s2).andThen s3).run x =
      (s1.andThen (s2.andThen s3)).run x := by
  rfl


end Stage
end Ch27Stage
