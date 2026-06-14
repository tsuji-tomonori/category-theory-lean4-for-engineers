-- Source: chapters/ch16_relations_preorders_galois.tex:394

theorem detail_covered_by_allowed (d : Detail) :
    detailLe d (allow (erase d)) := by
  exact gc_unit erase_allow_galois view_refl d

theorem allowed_abstraction_is_inside (v : PublicView) :
    viewLe (erase (allow v)) v := by
  exact gc_counit erase_allow_galois detail_refl v


end Ch16
