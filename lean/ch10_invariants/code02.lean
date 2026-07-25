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
-- 出力: 100

def AccountValid (a : Account) : Prop :=
  0 < a.ownerId

def deposit (a : Account) (amount : Nat) : Account :=
  { a with balance := a.balance + amount }

-- h は「入力口座 a が AccountValid を満たす」という証明。
-- 入金しても AccountValid は保たれる。
theorem deposit_preserves_valid
    (a : Account) (amount : Nat)
    (h : AccountValid a) :
    AccountValid (deposit a amount) := by
  -- h     : AccountValid a
  -- ゴール: AccountValid (deposit a amount)
  -- 両方を定義展開して同じ命題にし、h を再利用する。
  simpa [deposit, AccountValid] using h
