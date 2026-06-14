-- Source: chapters/ch34_mathlib_category_theory.tex:147

theorem id_then (f : X ⟶ Y) : (𝟙 X) ≫ f = f := by
  simpa

theorem then_id (f : X ⟶ Y) : f ≫ (𝟙 Y) = f := by
  simpa

theorem comp_assoc_example
    (f : W ⟶ X) (g : X ⟶ Y) (h : Y ⟶ Z) :
    (f ≫ g) ≫ h = f ≫ (g ≫ h) := by
  simpa using (Category.assoc f g h)

end CategoryFields

section FunctorFields

variable {C : Type u1} [Category.{v1} C]
variable {D : Type u2} [Category.{v2} D]
variable (F : C ⥤ D)

#check F.obj
#check F.map
#check fun {X Y : C} (f : X ⟶ Y) => F.map f
