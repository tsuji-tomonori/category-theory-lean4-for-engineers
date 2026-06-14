-- Source: chapters/ch33_topos_type_theory_spec_languages.tex:198

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
