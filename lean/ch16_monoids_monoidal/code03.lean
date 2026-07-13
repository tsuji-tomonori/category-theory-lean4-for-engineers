-- 出典: chapters/ch16_monoids_monoidal.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter16

abbrev Log := List String

def emptyLog : Log := []

def combineLog (a b : Log) : Log :=
  a ++ b

#eval combineLog ["start"] ["end"]

theorem combineLog_empty_left (xs : Log) :
    combineLog emptyLog xs = xs := by
  rfl

theorem combineLog_empty_right (xs : Log) :
    combineLog xs emptyLog = xs := by
  simp [combineLog, emptyLog]

theorem combineLog_assoc (a b c : Log) :
    combineLog (combineLog a b) c = combineLog a (combineLog b c) := by
  simp [combineLog]

structure SimpleMonoid (M : Type) where
  empty : M
  append : M -> M -> M
  empty_left : forall x, append empty x = x
  empty_right : forall x, append x empty = x
  append_assoc : forall x y z,
    append (append x y) z = append x (append y z)

def listNatMonoid : SimpleMonoid (List Nat) where
  empty := []
  append := fun xs ys => xs ++ ys
  empty_left := by
    intro xs
    rfl
  empty_right := by
    intro xs
    simp
  append_assoc := by
    intro xs ys zs
    simp

def planLeft (a b c : Log) : Log :=
  combineLog (combineLog a b) c

def planRight (a b c : Log) : Log :=
  combineLog a (combineLog b c)

theorem log_plan_safe (a b c : Log) :
    planLeft a b c = planRight a b c := by
  simpa [planLeft, planRight] using combineLog_assoc a b c
