-- Source: chapters/ch27_composable_design.tex:104

/-
Chapter 27: 合成可能な設計を作る
Lean examples for the chapter.
-/

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
