-- 出典: chapters/ch15_function_extensionality.tex:95
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch15

def pointwiseEq {α β : Type} (f g : α → β) : Prop :=
  ∀ x : α, f x = g x

theorem funext_from_pointwise
    {α β : Type} {f g : α → β}
    (h : pointwiseEq f g) : f = g := by
  funext x
  exact h x
