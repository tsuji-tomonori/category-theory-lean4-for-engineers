-- 出典: chapters/ch08_functor.tex:146
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter08

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
