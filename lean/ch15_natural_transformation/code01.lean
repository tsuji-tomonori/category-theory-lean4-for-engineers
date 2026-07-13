-- 出典: chapters/ch15_natural_transformation.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter15

def optionMap {A B : Type} (f : A -> B) : Option A -> Option B
  | none => none
  | some a => some (f a)

def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

#eval optionToList (some 10)
#eval optionToList (none : Option Nat)

theorem optionToList_naturality {A B : Type}
    (f : A -> B) (x : Option A) :
    optionToList (optionMap f x) =
      List.map f (optionToList x) := by
  cases x <;> rfl
