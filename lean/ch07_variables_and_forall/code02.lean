-- 出典: chapters/ch07_variables_and_forall.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def toDtoId (id : Nat) : Nat :=
  id

def PreservesId (f : Nat -> Nat) : Prop :=
  forall id, f id = id

theorem toDtoId_preservesId : PreservesId toDtoId := by
  intro id
  rfl
