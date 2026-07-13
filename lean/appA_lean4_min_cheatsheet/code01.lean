-- 出典: chapters/appA_lean4_min_cheatsheet.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def serviceFee : Nat := 300

def addFee (price : Nat) : Nat :=
  price + serviceFee

def inc (n : Nat) : Nat :=
  n + 1

def double (n : Nat) : Nat :=
  n * 2

def pipeline (n : Nat) : Nat :=
  double (inc n)

#eval addFee 1000
#eval pipeline 10
