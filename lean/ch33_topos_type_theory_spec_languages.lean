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

/-- ごく小さな仕様DSLの構文。 -/
inductive Spec where
  | truth : Spec
  | isActive : Spec
  | hasQuota : Nat -> Spec
  | and : Spec -> Spec -> Spec
deriving Repr, DecidableEq

/-- DSLの式を、文脈上の命題として解釈する。 -/
def holds (s : Spec) (u : UserCtx) : Prop :=
  match s with
  | Spec.truth => True
  | Spec.isActive => u.active = true
  | Spec.hasQuota n => n <= u.quota
  | Spec.and p q => And (holds p u) (holds q u)

/-- 「アップロード可能」をDSLで書いたもの。 -/
def uploadDSL : Spec :=
  Spec.and Spec.isActive (Spec.hasQuota 1)

/-- DSLの意味から、通常のLean命題を取り出せる。 -/
theorem uploadDSL_means_active (u : UserCtx) :
    holds uploadDSL u -> u.active = true := by
  intro h
  exact h.left

theorem uploadDSL_means_quota (u : UserCtx) :
    holds uploadDSL u -> 1 <= u.quota := by
  intro h
  exact h.right

/-- 仕様言語を「構文」と「意味論」の組として見る最小モデル。 -/
structure SpecLang where
  State : Type
  Formula : Type
  Semantics : Formula -> State -> Prop

def UserSpecLang : SpecLang where
  State := UserCtx
  Formula := Spec
  Semantics := holds

/-- 強い仕様が弱い仕様を含意する、という読み替え。 -/
def refines {A : Type} (p q : A -> Prop) : Prop :=
  forall x, p x -> q x

theorem and_refines_left {A : Type} (p q : A -> Prop) :
    refines (fun x => And (p x) (q x)) p := by
  intro x h
  exact h.left

end Chapter33
