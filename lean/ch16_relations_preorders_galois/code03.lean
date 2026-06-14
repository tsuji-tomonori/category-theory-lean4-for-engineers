-- Source: chapters/ch16_relations_preorders_galois.tex:144

inductive Detail where
  | publicLevel
  | internalLevel
  | secretLevel
deriving Repr, DecidableEq

-- public <= internal <= secret と読む。
def detailLe : Detail -> Detail -> Prop
  | .publicLevel, _ => True
  | .internalLevel, .internalLevel => True
  | .internalLevel, .secretLevel => True
  | .secretLevel, .secretLevel => True
  | _, _ => False

theorem detail_refl : forall d : Detail, detailLe d d := by
  intro d
  cases d <;> simp [detailLe]

theorem detail_trans :
    forall {a b c : Detail}, detailLe a b -> detailLe b c -> detailLe a c := by
  intro a b c hab hbc
  cases a <;> cases b <;> cases c <;> simp [detailLe] at *
