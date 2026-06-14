-- Source: chapters/ch20_price_spec.tex:335

/-- 2明細をそれぞれ丸める場合の税額。ここでは 10% を 1/10 として表す。 -/
def taxPerLine2 (a b : Money) : Money :=
  taxOnly 1 10 a + taxOnly 1 10 b

/-- 2明細を合算してから丸める場合の税額。 -/
def taxOnSum2 (a b : Money) : Money :=
  taxOnly 1 10 (a + b)

#eval taxPerLine2 9 9
#eval taxOnSum2 9 9

/-- 丸めの位置は、一般には入れ替えられない。 -/
theorem rounding_position_counterexample :
    taxPerLine2 9 9 ≠ taxOnSum2 9 9 := by
  decide


end Chapter20
