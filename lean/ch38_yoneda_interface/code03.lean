-- 出典: chapters/ch38_yoneda_interface.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter38

def observeAll {A : Type} (x : A) :
    (B : Type) -> (A -> B) -> B :=
  fun _ f => f x

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

structure User where
  id : Nat
  name : String

structure UserView where
  id : Nat
  name : String

def toView (u : User) : UserView :=
  { id := u.id, name := u.name }

theorem user_eq_from_view_eq {u v : User}
    (h : toView u = toView v) : u = v := by
  cases u
  cases v
  cases h
  rfl

def byId (u : User) : Nat := u.id

def sameById (u v : User) : Prop :=
  byId u = byId v

def userA : User := { id := 1, name := "Alice" }
def userB : User := { id := 1, name := "Alicia" }

example : sameById userA userB :=
  rfl

end Chapter38
