-- Source: chapters/ch33_topos_type_theory_spec_languages.tex:97

namespace Chapter33

/-- 本章で使う小さな「文脈」。
実務では、テナント、権限、残量、環境設定などが文脈になる。 -/
structure UserCtx where
  userId : Nat
  active : Bool
  quota : Nat
deriving Repr, DecidableEq

/-- 仕様を命題として読む例。 -/
def CanUpload (u : UserCtx) : Prop :=
  And (u.active = true) (0 < u.quota)

def uploadPolicy (u : UserCtx) : Prop :=
  CanUpload u

/-- 証明は、仕様から取り出せる保証を明示する。 -/
theorem uploadPolicy_requires_active (u : UserCtx) :
    uploadPolicy u -> u.active = true := by
  intro h
  exact h.left
