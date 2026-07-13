-- 出典: chapters/ch17_monad.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter17

def optPure {α : Type} (a : α) : Option α :=
  some a

def optBind {α β : Type} (x : Option α) (f : α → Option β) : Option β :=
  match x with
  | none => none
  | some a => f a

#eval optBind (some 10) (fun n => some (n + 1))
#eval optBind (none : Option Nat) (fun n => some (n + 1))
