-- 出典: chapters/ch15_function_extensionality.tex:131
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch15

def pointwiseEq {α β : Type} (f g : α → β) : Prop :=
  ∀ x : α, f x = g x

theorem funext_from_pointwise
    {α β : Type} {f g : α → β}
    (h : pointwiseEq f g) : f = g := by
  funext x
  exact h x

def oldPlusOne (n : Nat) : Nat :=
  (fun x => x + 1) n

def newPlusOne (n : Nat) : Nat :=
  n + 1

theorem oldPlusOne_eq_newPlusOne :
    oldPlusOne = newPlusOne := by
  funext n
  rfl
