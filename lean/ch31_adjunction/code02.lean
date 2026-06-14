-- 出典: chapters/ch31_adjunction.tex:152
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch31Adjunction

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
        simp [List.append, ih]
  assoc := by
    intro xs ys zs
    induction xs with
    | nil => rfl
    | cons x xs ih =>
        simp [List.append, ih]

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
