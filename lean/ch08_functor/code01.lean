-- Source: chapters/ch08_functor.tex:47

/-
第8章 関手：構造を保ったまま中身を変える
Lean 4 examples.
-/

namespace Chapter08

-- 単体の変換。
def addOne (n : Nat) : Nat :=
  n + 1

def isEven (n : Nat) : Bool :=
  n % 2 == 0
