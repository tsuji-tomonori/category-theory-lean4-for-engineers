-- 出典: chapters/appA_lean4_min_cheatsheet.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def inc (n : Nat) : Nat :=
  n + 1

def addTwo (n : Nat) : Nat :=
  n + 1 + 1

theorem every_nat_self : forall n : Nat, n = n := by
  intro n
  rfl

theorem addTwo_zero : addTwo 0 = 2 := by
  unfold addTwo
  rfl

example : (3 : Nat) < 5 := by
  decide

theorem inc_as_function : inc = (fun n => n + 1) := by
  funext n
  rfl

def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

theorem optionToList_length (x : Option Nat) :
    (optionToList x).length <= 1 := by
  cases x <;> simp [optionToList]
