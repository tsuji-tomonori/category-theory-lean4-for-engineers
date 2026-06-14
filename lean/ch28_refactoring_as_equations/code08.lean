-- Source: chapters/ch28_refactoring_as_equations.tex:272

-- Option における pure 相当の整理規則。
theorem option_bind_pure_left (x : Nat) (f : Nat -> Option Nat) :
    Option.bind (some x) f = f x := by
  rfl

theorem option_bind_pure_right (mx : Option Nat) :
    Option.bind mx some = mx := by
  cases mx with
  | none => rfl
  | some x => rfl


end Chapter28
