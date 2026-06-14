-- Source: chapters/ch05_category.tex:247

/-
Chapter 5: Category basics as types and functions.
This file contains the Lean snippets used in chapters/ch05_category.tex.
It intentionally avoids Mathlib's CategoryTheory API.
-/

namespace Ch05Category

-- 対象を型、射を関数として見る。
-- idFn は「何もしない処理」である。
def idFn {A : Type} (x : A) : A :=
  x

-- comp g f は「先に f、次に g」を実行する合成である。
def comp {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)
