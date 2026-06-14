-- 出典: chapters/ch34_mathlib_category_theory.tex:115
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

section CategoryLaws

variable {C : Type u} [Category.{v} C]
variable {W X Y Z : C}

theorem id_then (f : X ⟶ Y) : (𝟙 X) ≫ f = f := by
  simpa

theorem then_id (f : X ⟶ Y) : f ≫ (𝟙 Y) = f := by
  simpa

theorem comp_assoc_example
    (f : W ⟶ X) (g : X ⟶ Y) (h : Y ⟶ Z) :
    (f ≫ g) ≫ h = f ≫ (g ≫ h) := by
  simpa using (Category.assoc f g h)

end CategoryLaws
