-- Source: chapters/ch13_cases_patterns.tex:289

-- 入力パターンごとの結果。
theorem validate_no_name (age : Nat) :
    validate { namePresent := false, age := age } =
    ValidationResult.missingName := by
  rfl

theorem validate_age_zero :
    validate { namePresent := true, age := 0 } =
    ValidationResult.ageTooLow := by
  rfl

theorem validate_age_positive (n : Nat) :
    validate { namePresent := true, age := Nat.succ n } =
    ValidationResult.ok (Nat.succ n) := by
  rfl

-- 入力をすべて分解し、結果の事後条件を確認する。
theorem validate_result_post (input : SignupInput) :
    postcondition (validate input) := by
  cases input with
  | mk namePresent age =>
      cases namePresent with
      | false => rfl
      | true =>
          cases age with
          | zero => rfl
          | succ n => rfl


end Ch13CasesPatterns
