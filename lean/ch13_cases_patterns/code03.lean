-- Source: chapters/ch13_cases_patterns.tex:215

-- 実務寄りの小さな入力モデル。
structure SignupInput where
  namePresent : Bool
  age : Nat
deriving Repr

-- バリデーション結果を型として表す。
inductive ValidationResult where
  | ok : Nat -> ValidationResult
  | missingName : ValidationResult
  | ageTooLow : ValidationResult
deriving Repr

def validate (input : SignupInput) : ValidationResult :=
  match input.namePresent with
  | false => ValidationResult.missingName
  | true =>
      match input.age with
      | 0 => ValidationResult.ageTooLow
      | Nat.succ n => ValidationResult.ok (Nat.succ n)

def userIdOpt (r : ValidationResult) : Option Nat :=
  match r with
  | ValidationResult.ok userId => some userId
  | ValidationResult.missingName => none
  | ValidationResult.ageTooLow => none
