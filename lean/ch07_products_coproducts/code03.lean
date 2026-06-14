-- Source: chapters/ch07_products_coproducts.tex:128

structure LoginInput where
  userId : Nat
  token  : String

-- Records can be read as named products.
def loginAsPair (x : LoginInput) : Nat × String :=
  (x.userId, x.token)

def pairAsLogin (p : Nat × String) : LoginInput :=
  { userId := p.1, token := p.2 }

theorem pair_login_roundtrip (p : Nat × String) :
    loginAsPair (pairAsLogin p) = p := by
  cases p
  rfl
