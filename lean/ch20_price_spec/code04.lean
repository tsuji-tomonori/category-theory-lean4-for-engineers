-- Source: chapters/ch20_price_spec.tex:226

/-- 仕様上の標準順序：割引、手数料、固定税の順。 -/
def totalV1 (base discount fee tax : Money) : Money :=
  addFixedTax tax (addFee fee (applyDiscount discount base))

/-- リファクタリング後：割引後の金額に、固定税と手数料を逆順で加える。 -/
def totalV2 (base discount fee tax : Money) : Money :=
  addFee fee (addFixedTax tax (applyDiscount discount base))
