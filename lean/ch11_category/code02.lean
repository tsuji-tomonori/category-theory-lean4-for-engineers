-- 出典: chapters/ch05_category.tex:274
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch05Category

def idFn {A : Type} (x : A) : A :=
  x

def comp {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)

theorem id_left_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp idFn f x = f x := by
  rfl

theorem id_right_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp f idFn x = f x := by
  rfl

theorem comp_assoc_pointwise {A B C D : Type}
    (h : C -> D) (g : B -> C) (f : A -> B) (x : A) :
    comp (comp h g) f x = comp h (comp g f) x := by
  rfl
