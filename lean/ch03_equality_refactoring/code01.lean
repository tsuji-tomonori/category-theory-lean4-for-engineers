-- Source: chapters/ch03_equality_refactoring.tex:59

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
