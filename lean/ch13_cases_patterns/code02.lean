-- 出典: chapters/ch13_cases_patterns.tex:144
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch13CasesPatterns

def boolCode (b : Bool) : Nat :=
  match b with
  | true => 1
  | false => 0

theorem boolCode_all (b : Bool) :
    Or (boolCode b = 1) (boolCode b = 0) := by
  cases b with
  | false =>
      right
      rfl
  | true =>
      left
      rfl

def optionCode (x : Option Nat) : Nat :=
  match x with
  | none => 0
  | some _ => 1

theorem optionCode_all (x : Option Nat) :
    Or (And (x = none) (optionCode x = 0))
       (Exists fun n => And (x = some n) (optionCode x = 1)) := by
  cases x with
  | none =>
      exact Or.inl ⟨rfl, rfl⟩
  | some n =>
      exact Or.inr ⟨n, rfl, rfl⟩

def sumTag (x : Sum Nat Nat) : Nat :=
  match x with
  | Sum.inl _ => 0
  | Sum.inr _ => 1

theorem sumTag_is_left_or_right (x : Sum Nat Nat) :
    Or (Exists fun n => And (x = Sum.inl n)
                             (sumTag x = 0))
       (Exists fun n => And (x = Sum.inr n)
                             (sumTag x = 1)) := by
  cases x with
  | inl n =>
      exact Or.inl ⟨n, rfl, rfl⟩
  | inr n =>
      exact Or.inr ⟨n, rfl, rfl⟩
