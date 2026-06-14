-- 出典: chapters/ch04_invariants.tex:62
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter04

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
