-- 出典: chapters/ch07_variables_and_forall.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def inc : Nat -> Nat :=
  fun n => n + 1

def applyTwice (f : Nat -> Nat) (x : Nat) : Nat :=
  f (f x)

def compose {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)

#eval applyTwice inc 10
#eval compose inc inc 10
