-- Source: chapters/ch11_monad.tex:96

/-
第11章 モナド：失敗・状態・非同期を合成する形
このファイルは本文中の Lean コードを抜き出したものです。
Mathlib の CategoryTheory API は使わず、標準的な Lean 4 の構文と小さな自作定義だけで説明します。
-/

namespace Chapter11Monad

/-! ## Option の pure と bind -/

def optPure {α : Type} (a : α) : Option α :=
  some a

def optBind {α β : Type} (x : Option α) (f : α → Option β) : Option β :=
  match x with
  | none => none
  | some a => f a

#eval optBind (some 10) (fun n => some (n + 1))
#eval optBind (none : Option Nat) (fun n => some (n + 1))
