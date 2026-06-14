-- Source: chapters/ch28_refactoring_as_equations.tex:181

-- 恒等的な wrapper の削除。
def identityAdapter (x : Nat) : Nat := x

def wrappedNormalize (x : Nat) : Nat :=
  identityAdapter x

def directNormalize (x : Nat) : Nat :=
  x

theorem remove_identity_wrapper_preserves (x : Nat) :
    wrappedNormalize x = directNormalize x := by
  rfl
