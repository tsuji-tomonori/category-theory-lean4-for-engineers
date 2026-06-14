-- 出典: chapters/ch07_products_coproducts.tex:275
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch07

structure UserSummary where
  id   : Nat
  name : String

def loginPair : Nat × String := (42, "token")

example : loginPair.1 = 42 := rfl
example : loginPair.2 = "token" := rfl

theorem prod_eta {A B : Type} (p : A × B) : (p.1, p.2) = p := by
  cases p
  rfl

structure LoginInput where
  userId : Nat
  token  : String

def loginAsPair (x : LoginInput) : Nat × String :=
  (x.userId, x.token)

def pairAsLogin (p : Nat × String) : LoginInput :=
  { userId := p.1, token := p.2 }

theorem pair_login_roundtrip (p : Nat × String) :
    loginAsPair (pairAsLogin p) = p := by
  cases p
  rfl

theorem login_pair_roundtrip (x : LoginInput) :
    pairAsLogin (loginAsPair x) = x := by
  cases x
  rfl

inductive ParseError where
  | empty
  | badFormat

abbrev ParseResult := Sum ParseError Nat

def parseEmpty : ParseResult := Sum.inl ParseError.empty
def parseOk    : ParseResult := Sum.inr 200

def showParseResult (r : ParseResult) : String :=
  match r with
  | Sum.inl _ => "parse failed"
  | Sum.inr n => "parse ok"

def optionToSum {A : Type} : Option A → Sum Unit A
  | none   => Sum.inl ()
  | some a => Sum.inr a

def sumToOption {A : Type} : Sum Unit A → Option A
  | Sum.inl _ => none
  | Sum.inr a => some a

theorem option_roundtrip {A : Type} (x : Option A) :
    sumToOption (optionToSum x) = x := by
  cases x with
  | none => rfl
  | some a => rfl

theorem sum_option_roundtrip {A : Type} (s : Sum Unit A) :
    optionToSum (sumToOption s) = s := by
  cases s with
  | inl u =>
      cases u
      rfl
  | inr a => rfl

def makePair {A B C : Type} (f : C → A) (g : C → B) : C → A × B :=
  fun c => (f c, g c)

theorem makePair_fst {A B C : Type}
    (f : C → A) (g : C → B) (c : C) :
    (makePair f g c).1 = f c := rfl

theorem makePair_snd {A B C : Type}
    (f : C → A) (g : C → B) (c : C) :
    (makePair f g c).2 = g c := rfl

theorem makePair_unique_pointwise {A B C : Type}
    (f : C → A) (g : C → B) (h : C → A × B)
    (hfst : ∀ c, (h c).1 = f c)
    (hsnd : ∀ c, (h c).2 = g c)
    (c : C) : h c = makePair f g c := by
  calc
    h c = ((h c).1, (h c).2) := by
      cases h c
      rfl
    _ = (f c, g c) := by
      rw [hfst c, hsnd c]
    _ = makePair f g c := rfl
