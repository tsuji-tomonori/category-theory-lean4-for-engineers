-- Source: chapters/ch16_relations_preorders_galois.tex:54

namespace Ch16

-- A と B の間の関係は、A の値と B の値から命題を作るもの。
def Rel (A B : Type) := A -> B -> Prop

structure DetailLog where
  userId : Nat
  endpoint : Nat
  token : Nat
deriving Repr

structure PublicLog where
  endpoint : Nat
deriving Repr

-- 詳細ログから公開ログへ落とす。
def maskLog (l : DetailLog) : PublicLog :=
  { endpoint := l.endpoint }

-- 公開ログに残すと決めた部分が保存されている、という関係。
def KeepsPublicPart (d : DetailLog) (p : PublicLog) : Prop :=
  p.endpoint = d.endpoint

theorem maskLog_keeps_public (d : DetailLog) :
    KeepsPublicPart d (maskLog d) := by
  rfl
