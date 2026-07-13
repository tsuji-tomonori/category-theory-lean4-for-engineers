-- 出典: chapters/ch11_category.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter11

def idFn {A : Type} (x : A) : A :=
  x

def comp {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)
