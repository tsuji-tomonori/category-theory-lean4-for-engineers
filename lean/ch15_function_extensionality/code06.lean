-- Source: chapters/ch15_function_extensionality.tex:262

-- すべての Request で同じ Response を返すので、
-- 関数としても等しい。
theorem clientV1_eq_clientV2 :
    clientV1 = clientV2 := by
  funext r
  rfl
