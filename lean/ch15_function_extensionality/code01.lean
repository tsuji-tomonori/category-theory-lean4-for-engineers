-- Source: chapters/ch15_function_extensionality.tex:95

/-
Chapter 15: Function extensionality.
This file contains the Lean snippets used in
chapters/ch15_function_extensionality.tex.
-/

namespace Ch15

-- 点ごとの一致を、名前を付けて読みやすくする。
def pointwiseEq {α β : Type} (f g : α → β) : Prop :=
  ∀ x : α, f x = g x

-- すべての入力で同じなら、関数そのものも等しい。
theorem funext_from_pointwise
    {α β : Type} {f g : α → β}
    (h : pointwiseEq f g) : f = g := by
  funext x
  exact h x
