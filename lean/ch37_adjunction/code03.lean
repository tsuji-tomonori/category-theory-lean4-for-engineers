-- 出典: chapters/ch37_adjunction.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter37

structure TinyMonoid (M : Type) where
  unit : M
  op : M -> M -> M
  unit_left : forall x : M, op unit x = x
  unit_right : forall x : M, op x unit = x
  assoc : forall x y z : M,
    op (op x y) z = op x (op y z)

def listMonoid (A : Type) : TinyMonoid (List A) where
  unit := []
  op := List.append
  unit_left := by
    intro xs
    rfl
  unit_right := by
    intro xs
    induction xs with
    | nil => rfl
    | cons x xs ih =>
        simp [List.append]
  assoc := by
    intro xs ys zs
    induction xs with
    | nil => rfl
    | cons x xs ih =>
        simp [List.append]

structure MonoidObject where
  Carrier : Type
  monoid : TinyMonoid Carrier

def forget (X : MonoidObject) : Type := X.Carrier

def freeList (A : Type) : MonoidObject where
  Carrier := List A
  monoid := listMonoid A

def foldMap {A M : Type} (mon : TinyMonoid M)
    (f : A -> M) : List A -> M
  | [] => mon.unit
  | x :: xs => mon.op (f x) (foldMap mon f xs)

theorem foldMap_nil {A M : Type}
    (mon : TinyMonoid M) (f : A -> M) :
    foldMap mon f [] = mon.unit := by
  rfl

theorem foldMap_singleton {A M : Type}
    (mon : TinyMonoid M) (f : A -> M) (a : A) :
    foldMap mon f [a] = f a := by
  simp [foldMap, mon.unit_right]

theorem foldMap_append {A M : Type}
    (mon : TinyMonoid M) (f : A -> M) :
    forall xs ys : List A,
      foldMap mon f (xs ++ ys) =
        mon.op (foldMap mon f xs) (foldMap mon f ys) := by
  intro xs
  induction xs with
  | nil =>
      intro ys
      simp [foldMap, mon.unit_left]
  | cons x xs ih =>
      intro ys
      simp [foldMap, ih, mon.assoc]

structure MonoidHom (M N : Type)
    (monM : TinyMonoid M) (monN : TinyMonoid N) where
  toFun : M -> N
  map_unit : toFun monM.unit = monN.unit
  map_op : forall x y : M,
    toFun (monM.op x y) = monN.op (toFun x) (toFun y)

def foldMapHom {A M : Type} (mon : TinyMonoid M) (f : A -> M) :
    MonoidHom (List A) M (listMonoid A) mon where
  toFun := foldMap mon f
  map_unit := rfl
  map_op := by
    intro xs ys
    exact foldMap_append mon f xs ys

theorem foldMapHom_extends {A M : Type}
    (mon : TinyMonoid M) (f : A -> M) (a : A) :
    (foldMapHom mon f).toFun [a] = f a := by
  simp [foldMapHom, foldMap, mon.unit_right]

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

structure GaloisConnection {A B : Type}
    (leA : A -> A -> Prop) (leB : B -> B -> Prop)
    (lower : A -> B) (upper : B -> A) : Prop where
  condition : forall a b,
    leB (lower a) b <-> leA a (upper b)

end Chapter37
