-- Source: chapters/ch32_yoneda_interface.tex:204

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
