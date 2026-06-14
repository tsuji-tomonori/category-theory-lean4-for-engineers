-- Source: chapters/ch07_products_coproducts.tex:217

-- Option A can be read as Unit + A.
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
