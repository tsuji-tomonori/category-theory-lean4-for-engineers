-- Source: chapters/ch15_function_extensionality.tex:229

structure Request where
  userId : Nat
  amount : Nat
deriving Repr

structure Response where
  status : Nat
  value : Nat
deriving Repr

-- 旧 client。金額に 1 を足して返すだけの単純モデル。
def clientV1 (r : Request) : Response :=
  { status := 200, value := r.amount + 1 }

-- 新 client。補助的な let を使うが、返す値は同じ。
def clientV2 (r : Request) : Response :=
  let calculated := r.amount + 1
  { status := 200, value := calculated }

#eval clientV1 { userId := 1, amount := 100 }
