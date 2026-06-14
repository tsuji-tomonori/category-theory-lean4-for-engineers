-- Source: chapters/ch32_yoneda_interface.tex:148

namespace Ch32YonedaInterface

-- A value x : A can be seen through any observer f : A -> B.
def observeAll {A : Type} (x : A) :
    (B : Type) -> (A -> B) -> B :=
  fun B f => f x

-- Observing by the identity function recovers the original value.
theorem recover_by_id {A : Type} (x : A) :
    observeAll x A (fun a => a) = x :=
  rfl

-- If every possible observer sees x and y as equal,
-- then x and y are equal. Use the identity observer.
theorem same_by_all_observers {A : Type} {x y : A}
    (h : forall (B : Type) (f : A -> B), f x = f y) :
    x = y :=
  h A (fun a => a)
