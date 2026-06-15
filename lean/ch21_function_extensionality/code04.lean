-- 出典: chapters/ch15_function_extensionality.tex:200
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

def noopWrapper {α β : Type} (f : α → β) : α → β :=
  fun x => f x

theorem noopWrapper_eq {α β : Type} (f : α → β) :
    noopWrapper f = f := by
  funext x
  rfl

theorem apply_pointwise
    {α β : Type} {f g : α → β}
    (h : ∀ x : α, f x = g x) (x : α) :
    f x = g x := by
  exact h x

theorem function_eq_to_pointwise
    {α β : Type} {f g : α → β}
    (h : f = g) :
    ∀ x : α, f x = g x := by
  intro x
  rw [h]
