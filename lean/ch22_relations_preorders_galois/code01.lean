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
