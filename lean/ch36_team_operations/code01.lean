-- 出典: chapters/ch36_team_operations.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter36

inductive SpecStatus where
  | draft
  | reviewed
  | proved

deriving Repr, DecidableEq

structure SpecItem where
  id : Nat
  title : String
  status : SpecStatus

def markProved (s : SpecItem) : SpecItem :=
  { s with status := SpecStatus.proved }

def IsProved (s : SpecItem) : Prop :=
  s.status = SpecStatus.proved

theorem markProved_isProved (s : SpecItem) :
    IsProved (markProved s) := by
  unfold IsProved markProved
  rfl
