-- Source: chapters/ch13_cases_patterns.tex:93

namespace Ch13CasesPatterns

-- Bool は false / true の二通りに分解できる。
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

-- Option は none / some の二通りに分解できる。
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
