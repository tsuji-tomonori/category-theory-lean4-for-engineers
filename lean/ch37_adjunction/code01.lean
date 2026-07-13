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
