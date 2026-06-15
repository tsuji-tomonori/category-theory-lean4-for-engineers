-- 出典: chapters/ch08_simp_rw.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def addTax (price tax : Nat) : Nat :=
  price + tax

def normalizePrice (price : Nat) : Nat :=
  price

theorem normalizePrice_eq (price : Nat) :
    normalizePrice price = price := by
  rfl

theorem addTax_after_normalize (price tax : Nat) :
    addTax (normalizePrice price) tax = addTax price tax := by
  rw [normalizePrice_eq]
