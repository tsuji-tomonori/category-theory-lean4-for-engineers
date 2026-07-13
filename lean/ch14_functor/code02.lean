-- 出典: chapters/ch14_functor.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter14

def addOne (n : Nat) : Nat :=
  n + 1

def isEven (n : Nat) : Bool :=
  n % 2 == 0

theorem list_map_id {A : Type} (xs : List A) :
    List.map (fun x => x) xs = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]
