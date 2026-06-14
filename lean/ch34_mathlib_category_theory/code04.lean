-- Source: chapters/ch34_mathlib_category_theory.tex:179
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

section FunctorLaws

variable {C : Type u1} [Category.{v1} C]
variable {D : Type u2} [Category.{v2} D]
variable (F : C ⥤ D)

theorem functor_preserves_id (X : C) :
    F.map (𝟙 X) = 𝟙 (F.obj X) := by
  simpa using F.map_id X

theorem functor_preserves_comp {X Y Z : C}
    (f : X ⟶ Y) (g : Y ⟶ Z) :
    F.map (f ≫ g) = F.map f ≫ F.map g := by
  simpa using F.map_comp f g

end FunctorLaws
