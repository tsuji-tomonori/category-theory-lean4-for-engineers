-- 出典: chapters/ch28_refactoring_as_equations.tex:250
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter28

def basePrice (subtotal shipping : Nat) : Nat :=
  subtotal + shipping

def tax10 (n : Nat) : Nat :=
  n / 10

def totalBefore (subtotal shipping : Nat) : Nat :=
  (subtotal + shipping) + ((subtotal + shipping) / 10)

def totalAfter (subtotal shipping : Nat) : Nat :=
  let base := basePrice subtotal shipping
  base + tax10 base

theorem extract_base_price_preserves (subtotal shipping : Nat) :
    totalAfter subtotal shipping = totalBefore subtotal shipping := by
  rfl

def addServiceFee (fee amount : Nat) : Nat :=
  amount + fee

def addHandlingFee (fee amount : Nat) : Nat :=
  amount + fee

theorem independent_fee_order (amount service handling : Nat) :
    addHandlingFee handling (addServiceFee service amount) =
    addServiceFee service (addHandlingFee handling amount) := by
  unfold addHandlingFee addServiceFee
  calc
    (amount + service) + handling = amount + (service + handling) := by
      rw [Nat.add_assoc]
    _ = amount + (handling + service) := by
      rw [Nat.add_comm service handling]
    _ = (amount + handling) + service := by
      rw [← Nat.add_assoc]

def double (n : Nat) : Nat := n * 2

def addOne (n : Nat) : Nat := n + 1

example : double (addOne 3) ≠ addOne (double 3) := by
  decide

def discountCore (useCoupon : Bool) (price : Nat) : Nat :=
  if useCoupon then price - 10 else price

def oldWithoutCoupon (price : Nat) : Nat :=
  price

def newWithoutCoupon (price : Nat) : Nat :=
  discountCore false price

theorem commonize_without_coupon_preserves (price : Nat) :
    newWithoutCoupon price = oldWithoutCoupon price := by
  rfl

def identityAdapter (x : Nat) : Nat := x

def wrappedNormalize (x : Nat) : Nat :=
  identityAdapter x

def directNormalize (x : Nat) : Nat :=
  x

theorem remove_identity_wrapper_preserves (x : Nat) :
    wrappedNormalize x = directNormalize x := by
  rfl

def parsePositive (n : Nat) : Option Nat :=
  if n = 0 then none else some n

def checkEven (n : Nat) : Option Nat :=
  if n % 2 = 0 then some n else none

def enrich (n : Nat) : Option Nat :=
  some (n + 1)

def flowBefore (n : Nat) : Option Nat :=
  Option.bind (parsePositive n) (fun x =>
    Option.bind (checkEven x) enrich)

def flowAfter (n : Nat) : Option Nat :=
  Option.bind (Option.bind (parsePositive n) checkEven) enrich

theorem option_assoc_refactor_preserves (n : Nat) :
    flowBefore n = flowAfter n := by
  unfold flowBefore flowAfter
  cases parsePositive n with
  | none => rfl
  | some x =>
      cases checkEven x with
      | none => rfl
      | some y => rfl
