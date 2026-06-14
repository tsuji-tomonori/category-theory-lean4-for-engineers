-- Source: chapters/ch21_migration_classification.tex:102

/-
Chapter 21: マイグレーションを数学的に分類する

このファイルは本文中の Lean コードをまとめたものです。
Mathlib の高度な圏論 API は使わず、標準的な Lean 4 だけで
マイグレーションの分類を小さく表します。
-/

namespace Ch21MigrationClassification

/-- 完全同型を表す最小構造。 -/
structure EquivLike (A B : Type) where
  toFun : A -> B
  invFun : B -> A
  left_inv : (a : A) -> invFun (toFun a) = a
  right_inv : (b : B) -> toFun (invFun b) = b
