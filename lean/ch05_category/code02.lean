-- Source: chapters/ch05_category.tex:274

-- 左から恒等処理を合成しても、結果は変わらない。
theorem id_left_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp idFn f x = f x := by
  rfl

-- 右から恒等処理を合成しても、結果は変わらない。
theorem id_right_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp f idFn x = f x := by
  rfl

-- 三つの関数を合成するとき、括弧の付け方は結果に影響しない。
theorem comp_assoc_pointwise {A B C D : Type}
    (h : C -> D) (g : B -> C) (f : A -> B) (x : A) :
    comp (comp h g) f x = comp h (comp g f) x := by
  rfl
