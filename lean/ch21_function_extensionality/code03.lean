-- 出典: chapters/ch21_function_extensionality.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter21

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
