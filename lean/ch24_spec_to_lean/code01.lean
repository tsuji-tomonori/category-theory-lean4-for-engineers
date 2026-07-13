-- 出典: chapters/ch24_spec_to_lean.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter24

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
