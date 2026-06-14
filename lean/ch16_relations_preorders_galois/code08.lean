-- Source: chapters/ch16_relations_preorders_galois.tex:283

theorem view_refl : forall v : PublicView, viewLe v v := by
  intro v
  cases v <;> simp [viewLe]

theorem view_trans :
    forall {a b c : PublicView}, viewLe a b -> viewLe b c -> viewLe a c := by
  intro a b c hab hbc
  cases a <;> cases b <;> cases c <;> simp [viewLe] at *

def PublicViewPreorder : PreorderMini PublicView where
  le := viewLe
  refl := view_refl
  trans := by
    intro a b c hab hbc
    exact view_trans hab hbc

theorem erase_monotone :
    MonotoneMini (A := Detail) (B := PublicView) detailLe viewLe erase := by
  intro x y h
  cases x <;> cases y <;> simp [detailLe, viewLe, erase] at *

theorem allow_monotone :
    MonotoneMini (A := PublicView) (B := Detail) viewLe detailLe allow := by
  intro x y h
  cases x <;> cases y <;> simp [viewLe, detailLe, allow] at *
