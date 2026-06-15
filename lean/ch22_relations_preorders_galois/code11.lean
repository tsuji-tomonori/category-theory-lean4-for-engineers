-- 出典: chapters/ch16_relations_preorders_galois.tex:394
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch16

def Rel (A B : Type) := A -> B -> Prop

structure DetailLog where
  userId : Nat
  endpoint : Nat
  token : Nat
deriving Repr

structure PublicLog where
  endpoint : Nat
deriving Repr

def maskLog (l : DetailLog) : PublicLog :=
  { endpoint := l.endpoint }

def KeepsPublicPart (d : DetailLog) (p : PublicLog) : Prop :=
  p.endpoint = d.endpoint

theorem maskLog_keeps_public (d : DetailLog) :
    KeepsPublicPart d (maskLog d) := by
  rfl

structure PreorderMini (A : Type) where
  le : A -> A -> Prop
  refl : forall a, le a a
  trans : forall {a b c}, le a b -> le b c -> le a c

inductive Detail where
  | publicLevel
  | internalLevel
  | secretLevel
deriving Repr, DecidableEq

def detailLe : Detail -> Detail -> Prop
  | .publicLevel, _ => True
  | .internalLevel, .internalLevel => True
  | .internalLevel, .secretLevel => True
  | .secretLevel, .secretLevel => True
  | _, _ => False

theorem detail_refl : forall d : Detail, detailLe d d := by
  intro d
  cases d <;> simp [detailLe]

theorem detail_trans :
    forall {a b c : Detail}, detailLe a b -> detailLe b c -> detailLe a c := by
  intro a b c hab hbc
  cases a <;> cases b <;> cases c <;> simp [detailLe] at *

def DetailPreorder : PreorderMini Detail where
  le := detailLe
  refl := detail_refl
  trans := by
    intro a b c hab hbc
    exact detail_trans hab hbc

theorem no_secret_as_public :
    detailLe Detail.secretLevel Detail.publicLevel -> False := by
  intro h
  simpa [detailLe] using h

def Stronger {A : Type} (p q : A -> Prop) : Prop :=
  forall x, p x -> q x

theorem stronger_refl {A : Type} (p : A -> Prop) :
    Stronger p p := by
  intro x hx
  exact hx

theorem stronger_trans {A : Type} {p q r : A -> Prop} :
    Stronger p q -> Stronger q r -> Stronger p r := by
  intro hpq hqr x hpx
  exact hqr x (hpq x hpx)

def MonotoneMini {A B : Type}
    (leA : A -> A -> Prop) (leB : B -> B -> Prop)
    (f : A -> B) : Prop :=
  forall {x y}, leA x y -> leB (f x) (f y)

inductive PublicView where
  | publicOnly
  | mayContainPrivate
deriving Repr, DecidableEq

def viewLe : PublicView -> PublicView -> Prop
  | .publicOnly, _ => True
  | .mayContainPrivate, .mayContainPrivate => True
  | .mayContainPrivate, .publicOnly => False

def erase : Detail -> PublicView
  | .publicLevel => .publicOnly
  | .internalLevel => .mayContainPrivate
  | .secretLevel => .mayContainPrivate

def allow : PublicView -> Detail
  | .publicOnly => .publicLevel
  | .mayContainPrivate => .secretLevel

theorem view_refl : forall v : PublicView, viewLe v v := by
  intro v
  cases v <;> simp [viewLe]

theorem view_trans :
    forall {a b c : PublicView}, viewLe a b -> viewLe b c -> viewLe a c := by
  intro a b c hab hbc
  cases a <;> cases b <;> cases c <;> simp [viewLe] at *

def PublicViewPreorder : PreorderMini PublicView where
  le := viewLe
  refl := view_refl
  trans := by
    intro a b c hab hbc
    exact view_trans hab hbc

theorem erase_monotone :
    MonotoneMini (A := Detail) (B := PublicView) detailLe viewLe erase := by
  intro x y h
  cases x <;> cases y <;> simp [detailLe, viewLe, erase] at *

theorem allow_monotone :
    MonotoneMini (A := PublicView) (B := Detail) viewLe detailLe allow := by
  intro x y h
  cases x <;> cases y <;> simp [viewLe, detailLe, allow] at *

structure GaloisConnectionMini (C A : Type)
    (cLe : C -> C -> Prop) (aLe : A -> A -> Prop)
    (alpha : C -> A) (gamma : A -> C) : Prop where
  law : forall c a, Iff (aLe (alpha c) a) (cLe c (gamma a))

theorem erase_allow_galois :
    GaloisConnectionMini Detail PublicView detailLe viewLe erase allow := by
  constructor
  intro c a
  cases c <;> cases a <;> simp [erase, allow, detailLe, viewLe]

theorem gc_unit {C A : Type} {cLe : C -> C -> Prop} {aLe : A -> A -> Prop}
    {alpha : C -> A} {gamma : A -> C}
    (gc : GaloisConnectionMini C A cLe aLe alpha gamma)
    (a_refl : forall a, aLe a a) :
    forall c, cLe c (gamma (alpha c)) := by
  intro c
  exact (gc.law c (alpha c)).mp (a_refl (alpha c))

theorem gc_counit {C A : Type} {cLe : C -> C -> Prop} {aLe : A -> A -> Prop}
    {alpha : C -> A} {gamma : A -> C}
    (gc : GaloisConnectionMini C A cLe aLe alpha gamma)
    (c_refl : forall c, cLe c c) :
    forall a, aLe (alpha (gamma a)) a := by
  intro a
  exact (gc.law (gamma a) a).mpr (c_refl (gamma a))

theorem detail_covered_by_allowed (d : Detail) :
    detailLe d (allow (erase d)) := by
  exact gc_unit erase_allow_galois view_refl d

theorem allowed_abstraction_is_inside (v : PublicView) :
    viewLe (erase (allow v)) v := by
  exact gc_counit erase_allow_galois detail_refl v

end Ch16
