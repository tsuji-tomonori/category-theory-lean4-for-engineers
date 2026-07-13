-- 出典: chapters/ch39_topos_type_theory_spec_languages.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter39

structure UserCtx where
  userId : Nat
  active : Bool
  quota : Nat
deriving Repr, DecidableEq

def CanUpload (u : UserCtx) : Prop :=
  And (u.active = true) (1 <= u.quota)

theorem canUpload_requires_active (u : UserCtx) :
    CanUpload u -> u.active = true := by
  intro h
  exact h.left
