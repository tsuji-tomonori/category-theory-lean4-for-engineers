-- 出典: chapters/ch18_spec_to_lean.tex:108
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter18

structure Account where
  balance : Nat
  deriving Repr, DecidableEq

def CanWithdraw (a : Account) (amount : Nat) : Prop :=
  amount <= a.balance

def withdraw (a : Account) (amount : Nat) : Option Account :=
  if amount <= a.balance then
    some { balance := a.balance - amount }
  else
    none
