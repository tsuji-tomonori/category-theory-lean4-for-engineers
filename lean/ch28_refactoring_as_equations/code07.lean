-- Source: chapters/ch28_refactoring_as_equations.tex:250

theorem option_assoc_refactor_preserves (n : Nat) :
    flowBefore n = flowAfter n := by
  unfold flowBefore flowAfter
  cases parsePositive n with
  | none => rfl
  | some x =>
      cases checkEven x with
      | none => rfl
      | some y => rfl
