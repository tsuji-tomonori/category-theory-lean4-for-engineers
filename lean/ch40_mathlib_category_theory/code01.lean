-- 出典: chapters/ch40_mathlib_category_theory.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Functor.Basic
import Mathlib.CategoryTheory.NatTrans
import Mathlib.CategoryTheory.Iso

universe v u v1 v2 u1 u2

namespace Chapter34

open CategoryTheory
open scoped CategoryTheory

section CategoryFields

variable {C : Type u} [Category.{v} C]
variable {W X Y Z : C}

#check (X ⟶ Y)
#check (𝟙 X)
#check fun (f : X ⟶ Y) (g : Y ⟶ Z) => f ≫ g
