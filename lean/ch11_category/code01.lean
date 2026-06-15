-- 出典: chapters/ch05_category.tex:247
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch05Category

def idFn {A : Type} (x : A) : A :=
  x

def comp {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)
