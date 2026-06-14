-- Source: chapters/ch13_cases_patterns.tex:254

-- 結果ごとの事後条件。
def postcondition (r : ValidationResult) : Prop :=
  match r with
  | ValidationResult.ok userId =>
      userIdOpt r = some userId
  | ValidationResult.missingName =>
      userIdOpt r = none
  | ValidationResult.ageTooLow =>
      userIdOpt r = none

theorem postcondition_all (r : ValidationResult) :
    postcondition r := by
  cases r with
  | ok userId =>
      rfl
  | missingName =>
      rfl
  | ageTooLow =>
      rfl
