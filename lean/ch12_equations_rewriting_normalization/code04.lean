-- Source: chapters/ch12_equations_rewriting_normalization.tex:166

-- この補題は simp が自動で使えるようにしておく。
@[simp] theorem addTax_zero_simp (n : Nat) :
    addTax n 0 = n := by
  unfold addTax
  simp

-- 何もしない正規化処理を、あえて関数として置く。
def normalizeCode (n : Nat) : Nat :=
  n + 0

def loadCode (n : Nat) : Nat :=
  normalizeCode (normalizeCode n)

@[simp] theorem normalizeCode_eq (n : Nat) :
    normalizeCode n = n := by
  unfold normalizeCode
  simp

theorem loadCode_normalized (n : Nat) :
    loadCode n = n := by
  simp [loadCode]
