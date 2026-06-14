-- Source: chapters/ch28_refactoring_as_equations.tex:101

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
