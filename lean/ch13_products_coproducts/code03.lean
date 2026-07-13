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
