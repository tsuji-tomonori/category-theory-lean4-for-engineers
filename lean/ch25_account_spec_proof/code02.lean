-- 出典: chapters/ch25_account_spec_proof.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter25

abbrev AccountId := Nat
abbrev Balance := Nat
abbrev Amount := Nat

structure Account where
  id : AccountId
  balance : Balance
deriving Repr, DecidableEq

def NonNegative (a : Account) : Prop :=
  0 <= a.balance

theorem account_nonnegative (a : Account) : NonNegative a := by
  exact Nat.zero_le a.balance

def deposit (a : Account) (amount : Amount) : Account :=
  { a with balance := a.balance + amount }

def withdraw? (a : Account) (amount : Amount) : Option Account :=
  if amount <= a.balance then
    some { a with balance := a.balance - amount }
  else
    none

def totalBalance (a b : Account) : Balance :=
  a.balance + b.balance

def transfer? (src to : Account) (amount : Amount) : Option (Account × Account) :=
  match withdraw? src amount with
  | none => none
  | some src' => some (src', deposit to amount)
