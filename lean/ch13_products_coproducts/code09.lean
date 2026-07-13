-- 出典: chapters/ch13_products_coproducts.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter13

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
  | Sum.inr _n => "parse ok"

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

def eitherElim {A B C : Type} (f : A → C) (g : B → C)
    (s : Sum A B) : C :=
  match s with
  | Sum.inl a => f a
  | Sum.inr b => g b

theorem eitherElim_inl {A B C : Type}
    (f : A → C) (g : B → C) (a : A) :
    eitherElim f g (Sum.inl a) = f a := rfl

theorem eitherElim_inr {A B C : Type}
    (f : A → C) (g : B → C) (b : B) :
    eitherElim f g (Sum.inr b) = g b := rfl

theorem eitherElim_unique_pointwise {A B C : Type}
    (f : A → C) (g : B → C) (h : Sum A B → C)
    (hl : ∀ a, h (Sum.inl a) = f a)
    (hr : ∀ b, h (Sum.inr b) = g b)
    (s : Sum A B) : h s = eitherElim f g s := by
  cases s with
  | inl a =>
      rw [hl a]
      rfl
  | inr b =>
      rw [hr b]
      rfl
