-- Source: chapters/ch34_mathlib_category_theory.tex:271

theorem naturality_example {X Y : C} (f : X ⟶ Y) :
    F.map f ≫ α.app Y = α.app X ≫ G.map f := by
  simpa using α.naturality f

end NatTransFields

section IsoFields

variable {C : Type u} [Category.{v} C]
variable {X Y : C}
variable (e : X ≅ Y)

#check e.hom
#check e.inv
#check e.hom_inv_id
#check e.inv_hom_id


theorem iso_roundtrip_left : e.hom ≫ e.inv = 𝟙 X := by
  simpa using e.hom_inv_id

theorem iso_roundtrip_right : e.inv ≫ e.hom = 𝟙 Y := by
  simpa using e.inv_hom_id

end IsoFields

end Chapter34
