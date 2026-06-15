-- 出典: chapters/ch16_relations_preorders_galois.tex:144
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
