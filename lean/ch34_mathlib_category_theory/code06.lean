-- Source: chapters/ch34_mathlib_category_theory.tex:240
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

section NatTransNaturality

variable {C : Type u1} [Category.{v1} C]
variable {D : Type u2} [Category.{v2} D]
variable {F G : C ⥤ D}
variable (α : NatTrans F G)

theorem naturality_example {X Y : C} (f : X ⟶ Y) :
    F.map f ≫ α.app Y = α.app X ≫ G.map f := by
  simpa using α.naturality f

end NatTransNaturality
