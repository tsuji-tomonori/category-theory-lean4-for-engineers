-- Source: chapters/app_c_property_patterns.tex:325

structure AccountPair where
  left : Nat
  right : Nat

def total (p : AccountPair) : Nat :=
  p.left + p.right

def swapAccounts (p : AccountPair) : AccountPair :=
  { left := p.right, right := p.left }

theorem swapAccounts_preserves_total (p : AccountPair) :
    total (swapAccounts p) = total p := by
  unfold total swapAccounts
  exact Nat.add_comm p.right p.left
