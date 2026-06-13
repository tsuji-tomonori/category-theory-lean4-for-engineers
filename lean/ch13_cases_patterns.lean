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
      left
      constructor <;> rfl
  | some n =>
      right
      exists n
      constructor <;> rfl

-- Sum は左 inl / 右 inr の二通りに分解できる。
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
      left
      exists n
      constructor <;> rfl
  | inr n =>
      right
      exists n
      constructor <;> rfl

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
