-- Source: chapters/ch29_spec_impl_test_proof.tex:272

/--
SPEC-CHARGE-001:
実装モデル chargeImpl は仕様モデル chargeSpec と一致する。
前提: 金額は Nat。丸め、税率、外部決済APIはモデル外。
-/
theorem SPEC_CHARGE_001 (i : PriceInput) :
    chargeImpl i = chargeSpec i := by
  exact charge_impl_matches_spec i


end Chapter29
