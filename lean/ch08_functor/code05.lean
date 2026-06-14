-- Source: chapters/ch08_functor.tex:255

-- 章内で使う小さな Result 型。
inductive Result (E : Type) (A : Type) where
  | ok : A -> Result E A
  | error : E -> Result E A

def Result.map {E A B : Type}
    (f : A -> B) : Result E A -> Result E B
  | Result.ok a => Result.ok (f a)
  | Result.error e => Result.error e
