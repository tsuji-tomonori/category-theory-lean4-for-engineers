-- Source: chapters/ch34_mathlib_category_theory.tex:210

theorem functor_preserves_id (X : C) :
    F.map (𝟙 X) = 𝟙 (F.obj X) := by
  simpa using F.map_id X

theorem functor_preserves_comp {X Y Z : C}
    (f : X ⟶ Y) (g : Y ⟶ Z) :
    F.map (f ≫ g) = F.map f ≫ F.map g := by
  simpa using F.map_comp f g

end FunctorFields

section NatTransFields

variable {C : Type u1} [Category.{v1} C]
variable {D : Type u2} [Category.{v2} D]
variable {F G : C ⥤ D}
variable (α : NatTrans F G)

#check fun (X : C) => α.app X
#check fun {X Y : C} (f : X ⟶ Y) => α.naturality f
