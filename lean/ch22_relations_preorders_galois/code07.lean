-- 出典: chapters/ch22_relations_preorders_galois.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter22

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
  simp [detailLe] at h

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
