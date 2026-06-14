-- Source: chapters/ch03_equality_refactoring.tex:249

-- 処理順序を変えてよいのは、必要な等式が証明できる場合だけである。
def addShipping (n : Nat) : Nat :=
  n + 500

def addHandling (n : Nat) : Nat :=
  n + 100

theorem add_steps_commute (n : Nat) :
    addHandling (addShipping n) = addShipping (addHandling n) := by
  unfold addHandling addShipping
  calc
    (n + 500) + 100 = n + (500 + 100) := by
      rw [Nat.add_assoc]
    _ = n + (100 + 500) := by
      rw [Nat.add_comm 500 100]
    _ = (n + 100) + 500 := by
      rw [← Nat.add_assoc]
