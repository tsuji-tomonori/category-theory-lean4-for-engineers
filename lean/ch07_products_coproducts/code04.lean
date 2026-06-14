-- Source: chapters/ch07_products_coproducts.tex:168

theorem login_pair_roundtrip (x : LoginInput) :
    pairAsLogin (loginAsPair x) = x := by
  cases x
  rfl

inductive ParseError where
  | empty
  | badFormat

abbrev ParseResult := Sum ParseError Nat

-- The left side is an error, and the right side is a success value.
def parseEmpty : ParseResult := Sum.inl ParseError.empty
def parseOk    : ParseResult := Sum.inr 200

def showParseResult (r : ParseResult) : String :=
  match r with
  | Sum.inl _ => "parse failed"
  | Sum.inr n => "parse ok"
