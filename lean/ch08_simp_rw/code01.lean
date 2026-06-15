-- 出典: chapters/ch08_simp_rw.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def chargeShipping (isMember : Bool) (shipping : Nat) : Nat :=
  if isMember then 0 else shipping

theorem member_shipping_zero (shipping : Nat) :
    chargeShipping true shipping = 0 := by
  simp [chargeShipping]

-- これは任意の shipping については証明できない。
-- shipping が 0 とは限らないため。
-- theorem nonmember_shipping_zero (shipping : Nat) :
--     chargeShipping false shipping = 0 := by
--   simp [chargeShipping]
