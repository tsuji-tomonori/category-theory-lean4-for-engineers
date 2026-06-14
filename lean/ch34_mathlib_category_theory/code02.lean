-- Source: chapters/ch34_mathlib_category_theory.tex:115
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

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
