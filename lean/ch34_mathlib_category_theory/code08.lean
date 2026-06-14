-- Source: chapters/ch34_mathlib_category_theory.tex:303
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

section IsoRoundTrip

variable {C : Type u} [Category.{v} C]
variable {X Y : C}
variable (e : X ≅ Y)

theorem iso_roundtrip_left : e.hom ≫ e.inv = 𝟙 X := by
  simpa using e.hom_inv_id

theorem iso_roundtrip_right : e.inv ≫ e.hom = 𝟙 Y := by
  simpa using e.inv_hom_id

end IsoRoundTrip
