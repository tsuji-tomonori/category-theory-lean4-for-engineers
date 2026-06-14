-- Source: chapters/ch18_spec_to_lean.tex:108

/-
第18章 仕様書を Lean に移す方法
Lean 4 examples extracted from chapters/ch18_spec_to_lean.tex.

このファイルは、自然言語仕様から型・関数・述語・定理を切り出す
最小モデルを示す。Mathlib には依存しない。
-/

namespace Chapter18

-- 本章では、金額を Nat で単純化する。
-- 現実の通貨、小数、丸めは後で境界として明示する。
structure Account where
  balance : Nat
  deriving Repr, DecidableEq

-- 出金が成功するための事前条件。
def CanWithdraw (a : Account) (amount : Nat) : Prop :=
  amount <= a.balance

-- 成功すれば更新後の口座を返す。
-- 失敗すれば none を返す。
def withdraw (a : Account) (amount : Nat) : Option Account :=
  if amount <= a.balance then
    some { balance := a.balance - amount }
  else
    none
