-- 出典: chapters/ch32_yoneda_interface.tex:148
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
