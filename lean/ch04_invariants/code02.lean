-- Source: chapters/ch04_invariants.tex:139

-- Account validity. In this toy model, ownerId = 0 is treated as invalid.
def AccountValid (a : Account) : Prop :=
  0 < a.ownerId

-- Deposit changes only the balance.
def deposit (a : Account) (amount : Nat) : Account :=
  { a with balance := a.balance + amount }

-- Deposit preserves account validity because it does not change ownerId.
theorem deposit_preserves_valid
    (a : Account) (amount : Nat)
    (h : AccountValid a) :
    AccountValid (deposit a amount) := by
  simpa [deposit, AccountValid] using h
