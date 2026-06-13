/-
Chapter 28: リファクタリングを等式として扱う

This file contains the Lean 4 snippets used in the chapter.
It avoids Mathlib-specific APIs and uses small standard-library examples.
-/

namespace Chapter28

-- 関数抽出: 補助関数を導入しても計算結果が同じであることを示す。
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

-- 処理順序変更: 独立した二つの加算は順序を入れ替えられる。
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

-- 順序を変えると意味が変わる例。
def double (n : Nat) : Nat := n * 2

def addOne (n : Nat) : Nat := n + 1

example : double (addOne 3) ≠ addOne (double 3) := by
  decide

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

-- 恒等的な wrapper の削除。
def identityAdapter (x : Nat) : Nat := x

def wrappedNormalize (x : Nat) : Nat :=
  identityAdapter x

def directNormalize (x : Nat) : Nat :=
  x

theorem remove_identity_wrapper_preserves (x : Nat) :
    wrappedNormalize x = directNormalize x := by
  rfl

-- Option を使った effectful code の整理。
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

-- Option における pure 相当の整理規則。
theorem option_bind_pure_left (x : Nat) (f : Nat -> Option Nat) :
    Option.bind (some x) f = f x := by
  rfl

theorem option_bind_pure_right (mx : Option Nat) :
    Option.bind mx some = mx := by
  cases mx with
  | none => rfl
  | some x => rfl

end Chapter28
