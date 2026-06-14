-- Source: chapters/ch03_equality_refactoring.tex:287

-- 反例の雰囲気: Nat の引き算は 0 で止まるため、順序で結果が変わる。
def discount100 (n : Nat) : Nat :=
  n - 100

#eval discount100 (addShipping 50)
#eval addShipping (discount100 50)


end Ch03EqualityRefactoring
