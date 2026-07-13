-- 出典: chapters/ch34_refactoring_as_equations.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter34

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
