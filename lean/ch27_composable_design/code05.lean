-- Source: chapters/ch27_composable_design.tex:241

end Ch27ETL

namespace Ch27Stage

structure Stage (A B : Type) where
  run : A -> B

namespace Stage

variable {A B C D : Type}

def id (A : Type) : Stage A A :=
  { run := fun x => x }

def andThen (s1 : Stage A B) (s2 : Stage B C) : Stage A C :=
  { run := Function.comp s2.run s1.run }

theorem left_id (s : Stage A B) (x : A) :
    ((id A).andThen s).run x = s.run x := by
  rfl
