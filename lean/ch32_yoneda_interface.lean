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

-- A small software-facing example.
structure User where
  id : Nat
  name : String

structure UserView where
  id : Nat
  name : String

def toView (u : User) : UserView :=
  { id := u.id, name := u.name }

-- In this simplified model, the full view determines the user.
theorem user_eq_from_view_eq {u v : User}
    (h : toView u = toView v) : u = v := by
  cases u
  cases v
  cases h
  rfl

-- A partial observer sees only the ID.
def byId (u : User) : Nat := u.id

def sameById (u v : User) : Prop :=
  byId u = byId v

def userA : User := { id := 1, name := "Alice" }
def userB : User := { id := 1, name := "Alicia" }

-- The two users agree under the ID-only observer.
example : sameById userA userB :=
  rfl

end Ch32YonedaInterface
