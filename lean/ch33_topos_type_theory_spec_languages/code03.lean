-- 出典: chapters/ch33_topos_type_theory_spec_languages.tex:198
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

theorem uploadDSL_means_active (u : UserCtx) :
    holds uploadDSL u -> u.active = true := by
  intro h
  exact h.left

theorem uploadDSL_means_quota (u : UserCtx) :
    holds uploadDSL u -> 1 <= u.quota := by
  intro h
  exact h.right

structure SpecLang where
  State : Type
  Formula : Type
  Semantics : Formula -> State -> Prop

def UserSpecLang : SpecLang where
  State := UserCtx
  Formula := Spec
  Semantics := holds

def refines {A : Type} (p q : A -> Prop) : Prop :=
  forall x, p x -> q x

theorem and_refines_left {A : Type} (p q : A -> Prop) :
    refines (fun x => And (p x) (q x)) p := by
  intro x h
  exact h.left

end Chapter33
