-- 出典: chapters/ch08_functor.tex:47
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter08

def addOne (n : Nat) : Nat :=
  n + 1

def isEven (n : Nat) : Bool :=
  n % 2 == 0
