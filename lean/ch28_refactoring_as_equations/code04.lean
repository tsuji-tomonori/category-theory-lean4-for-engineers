-- Source: chapters/ch28_refactoring_as_equations.tex:152

-- 共通化: 旧関数が共通関数の特定分岐と一致することを示す。
def discountCore (useCoupon : Bool) (price : Nat) : Nat :=
  if useCoupon then price - 10 else price

def oldWithoutCoupon (price : Nat) : Nat :=
  price

def newWithoutCoupon (price : Nat) : Nat :=
  discountCore false price

theorem commonize_without_coupon_preserves (price : Nat) :
    newWithoutCoupon price = oldWithoutCoupon price := by
  rfl
