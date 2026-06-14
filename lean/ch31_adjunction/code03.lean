-- Source: chapters/ch31_adjunction.tex:272

/-- foldMap is the homomorphism induced by an element-level map. -/
def foldMapHom {A M : Type} (mon : TinyMonoid M) (f : A -> M) :
    MonoidHom (List A) M (listMonoid A) mon where
  toFun := foldMap mon f
  map_unit := rfl
  map_op := by
    intro xs ys
    exact foldMap_append mon f xs ys

/-- The induced homomorphism extends the original element-level map. -/
theorem foldMapHom_extends {A M : Type}
    (mon : TinyMonoid M) (f : A -> M) (a : A) :
    (foldMapHom mon f).toFun [a] = f a := by
  simp [foldMapHom, foldMap, mon.unit_right]

/-- Uniqueness: any homomorphism extending f is foldMap f. -/
theorem foldMapHom_unique {A M : Type} (mon : TinyMonoid M) (f : A -> M)
    (h : MonoidHom (List A) M (listMonoid A) mon)
    (h_single : forall a : A, h.toFun [a] = f a) :
    forall xs : List A, h.toFun xs = foldMap mon f xs := by
  intro xs
  induction xs with
  | nil =>
      calc
        h.toFun [] = h.toFun ((listMonoid A).unit) := rfl
        _ = mon.unit := h.map_unit
        _ = foldMap mon f [] := rfl
  | cons x xs ih =>
      calc
        h.toFun (x :: xs) = h.toFun ([x] ++ xs) := rfl
        _ = mon.op (h.toFun [x]) (h.toFun xs) := h.map_op [x] xs
        _ = mon.op (f x) (foldMap mon f xs) := by
          simp [h_single x, ih]
        _ = foldMap mon f (x :: xs) := rfl

/-- Natural numbers under addition as a small target monoid. -/
def natAddMonoid : TinyMonoid Nat where
  unit := 0
  op := Nat.add
  unit_left := by
    intro x
    exact Nat.zero_add x
  unit_right := by
    intro x
    exact Nat.add_zero x
  assoc := by
    intro x y z
    exact Nat.add_assoc x y z

#eval foldMap natAddMonoid (fun n : Nat => n) [1, 2, 3]
#eval foldMap natAddMonoid (fun _ : String => 1) ["a", "b", "c"]

/-- A tiny definition of Galois connection between two preorders. -/
structure GaloisConnection {A B : Type}
    (leA : A -> A -> Prop) (leB : B -> B -> Prop)
    (lower : A -> B) (upper : B -> A) : Prop where
  condition : forall a b,
    leB (lower a) b <-> leA a (upper b)


end Ch31Adjunction
