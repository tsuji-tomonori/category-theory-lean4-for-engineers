-- Source: chapters/ch16_relations_preorders_galois.tex:127

-- 前順序の最小構造。
-- le は比較関係、refl は反射性、trans は推移性を表す。
structure PreorderMini (A : Type) where
  le : A -> A -> Prop
  refl : forall a, le a a
  trans : forall {a b c}, le a b -> le b c -> le a c
