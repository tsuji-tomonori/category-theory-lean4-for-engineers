namespace Ch03EqualityRefactoring

-- 第3章 等式推論とリファクタリング
-- 目的: リファクタリング前後の意味保存を、小さな等式として表す。

-- 何もしない整理は、simp で消せることが多い。
def rawCalc (x : Nat) : Nat :=
  (x + 0) * 1

def refactoredCalc (x : Nat) : Nat :=
  x

theorem rawCalc_eq_refactoredCalc (x : Nat) :
    rawCalc x = refactoredCalc x := by
  unfold rawCalc refactoredCalc
  simp

-- 関数の結果が同じ、という仕様を全入力についての命題にする。
def sameOnNat (f g : Nat → Nat) : Prop :=
  ∀ x, f x = g x

theorem raw_and_refactored_same :
    sameOnNat rawCalc refactoredCalc := by
  intro x
  unfold rawCalc refactoredCalc
  simp

-- rw は、既知の等式を使った置換として読める。
def addFeeOriginal (price fee : Nat) : Nat :=
  price + fee

def addFeeRefactored (price fee : Nat) : Nat :=
  fee + price

theorem addFee_refactor_preserves (price fee : Nat) :
    addFeeOriginal price fee = addFeeRefactored price fee := by
  unfold addFeeOriginal addFeeRefactored
  rw [Nat.add_comm]

-- calc は、レビューしやすい段階的な式変形である。
def totalOriginal (price qty shipping handling : Nat) : Nat :=
  ((price * qty) + shipping) + handling

def totalExtracted (price qty shipping handling : Nat) : Nat :=
  let subtotal := price * qty
  let extra := shipping + handling
  subtotal + extra

theorem total_extracted_preserves
    (price qty shipping handling : Nat) :
    totalOriginal price qty shipping handling =
      totalExtracted price qty shipping handling := by
  unfold totalOriginal totalExtracted
  calc
    ((price * qty) + shipping) + handling
        = (price * qty) + (shipping + handling) := by
          rw [Nat.add_assoc]

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

-- 反例の雰囲気: Nat の引き算は 0 で止まるため、順序で結果が変わる。
def discount100 (n : Nat) : Nat :=
  n - 100

#eval discount100 (addShipping 50)
#eval addShipping (discount100 50)

end Ch03EqualityRefactoring
