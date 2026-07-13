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

inductive Spec where
  | truth : Spec
  | isActive : Spec
  | hasQuota : Nat -> Spec
  | and : Spec -> Spec -> Spec
deriving Repr, DecidableEq

def holds (s : Spec) (u : UserCtx) : Prop :=
  match s with
  | Spec.truth => True
  | Spec.isActive => u.active = true
  | Spec.hasQuota n => n <= u.quota
  | Spec.and p q => And (holds p u) (holds q u)

def uploadDSL : Spec :=
  Spec.and Spec.isActive (Spec.hasQuota 1)

theorem uploadDSL_correct (u : UserCtx) :
    holds uploadDSL u <-> CanUpload u := by
  rfl
