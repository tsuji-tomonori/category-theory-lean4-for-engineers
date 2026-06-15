-- 出典: chapters/ch30_team_operations.tex:90
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter30

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
