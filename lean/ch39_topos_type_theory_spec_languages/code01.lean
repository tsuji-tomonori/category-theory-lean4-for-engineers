-- 出典: chapters/ch33_topos_type_theory_spec_languages.tex:97
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter33

structure UserCtx where
  userId : Nat
  active : Bool
  quota : Nat
deriving Repr, DecidableEq

def CanUpload (u : UserCtx) : Prop :=
  And (u.active = true) (0 < u.quota)

def uploadPolicy (u : UserCtx) : Prop :=
  CanUpload u

theorem uploadPolicy_requires_active (u : UserCtx) :
    uploadPolicy u -> u.active = true := by
  intro h
  exact h.left
