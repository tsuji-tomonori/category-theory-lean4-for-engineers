-- Source: chapters/ch33_topos_type_theory_spec_languages.tex:143

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
