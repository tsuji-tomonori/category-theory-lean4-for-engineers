-- Source: chapters/ch29_spec_impl_test_proof.tex:132

#eval chargeImpl { base := 100, discount := 10, shipping := 5 }

example :
    chargeImpl { base := 100, discount := 10, shipping := 5 } = 95 := by
  rfl

example :
    chargeImpl { base := 8, discount := 10, shipping := 5 } = 5 := by
  rfl
