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
