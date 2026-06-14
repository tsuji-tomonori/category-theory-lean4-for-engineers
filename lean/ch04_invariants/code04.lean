-- Source: chapters/ch04_invariants.tex:288

-- Valid accounts as a subtype.
def ValidAccount : Type :=
  { a : Account // AccountValid a }

-- Extract a field from the value inside the subtype.
def validAccountBalance (a : ValidAccount) : Nat :=
  a.val.balance

-- Deposit on ValidAccount returns another ValidAccount.
def depositValid (a : ValidAccount) (amount : Nat) : ValidAccount :=
  Subtype.mk (deposit a.val amount)
    (deposit_preserves_valid a.val amount a.property)
