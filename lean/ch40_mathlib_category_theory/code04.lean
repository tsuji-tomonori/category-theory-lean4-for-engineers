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

theorem id_then (f : X ⟶ Y) : (𝟙 X) ≫ f = f := by
  simp

theorem then_id (f : X ⟶ Y) : f ≫ (𝟙 Y) = f := by
  simp

theorem comp_assoc_example
    (f : W ⟶ X) (g : X ⟶ Y) (h : Y ⟶ Z) :
    (f ≫ g) ≫ h = f ≫ (g ≫ h) := by
  simp

end CategoryFields

section FunctorFields

variable {C : Type u1} [Category.{v1} C]
variable {D : Type u2} [Category.{v2} D]
variable (F : C ⥤ D)

#check F.obj
#check F.map
#check fun {X Y : C} (f : X ⟶ Y) => F.map f

section FunctorLaws

variable {C : Type u1} [Category.{v1} C]
variable {D : Type u2} [Category.{v2} D]
variable (F : C ⥤ D)

theorem functor_preserves_id (X : C) :
    F.map (𝟙 X) = 𝟙 (F.obj X) := by
  simp

theorem functor_preserves_comp {X Y Z : C}
    (f : X ⟶ Y) (g : Y ⟶ Z) :
    F.map (f ≫ g) = F.map f ≫ F.map g := by
  simp

end FunctorLaws
