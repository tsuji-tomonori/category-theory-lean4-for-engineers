-- 出典: chapters/ch32_yoneda_interface.tex:171
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch32YonedaInterface

def observeAll {A : Type} (x : A) :
    (B : Type) -> (A -> B) -> B :=
  fun B f => f x

theorem recover_by_id {A : Type} (x : A) :
    observeAll x A (fun a => a) = x :=
  rfl

theorem same_by_all_observers {A : Type} {x y : A}
    (h : forall (B : Type) (f : A -> B), f x = f y) :
    x = y :=
  h A (fun a => a)

def post {A B C : Type} (g : B -> C) (f : A -> B) :
    A -> C :=
  fun a => g (f a)

theorem equal_values_same_observations
    {A B : Type} {x y : A}
    (h : x = y) (f : A -> B) :
    f x = f y := by
  cases h
  rfl

theorem observation_commutes {A B C : Type} (x : A)
    (f : A -> B) (g : B -> C) :
    g (observeAll x B f) =
      observeAll x C (post g f) :=
  rfl
