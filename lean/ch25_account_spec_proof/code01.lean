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
