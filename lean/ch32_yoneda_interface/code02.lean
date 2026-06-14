-- Source: chapters/ch32_yoneda_interface.tex:171

-- Postprocessing an observation is the same as observing by a composite.
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
