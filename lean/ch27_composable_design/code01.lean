-- 出典: chapters/ch27_composable_design.tex:104
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch27

variable {A B C D : Type}

theorem left_id_point (f : A -> B) (x : A) :
    (Function.comp id f) x = f x := by
  rfl

theorem right_id_point (f : A -> B) (x : A) :
    (Function.comp f id) x = f x := by
  rfl

theorem assoc_point
    (f : A -> B) (g : B -> C) (h : C -> D) (x : A) :
    (Function.comp h (Function.comp g f)) x =
      (Function.comp (Function.comp h g) f) x := by
  rfl
