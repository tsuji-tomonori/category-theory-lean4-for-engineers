-- 出典: chapters/ch10_invariants.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter10

structure User where
  id : Nat
  name : String
  deriving Repr, DecidableEq

structure Account where
  ownerId : Nat
  balance : Nat
  deriving Repr, DecidableEq

def sampleAccount : Account :=
  { ownerId := 1, balance := 100 }

#eval sampleAccount.balance

def AccountValid (a : Account) : Prop :=
  0 < a.ownerId

def deposit (a : Account) (amount : Nat) : Account :=
  { a with balance := a.balance + amount }

theorem deposit_preserves_valid
    (a : Account) (amount : Nat)
    (h : AccountValid a) :
    AccountValid (deposit a amount) := by
  simpa [deposit, AccountValid] using h
