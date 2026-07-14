-- 出典: chapters/ch27_migration_classification.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter27

structure EquivMini (A B : Type) where
  toFun : A -> B
  invFun : B -> A
  left_inv : (a : A) -> invFun (toFun a) = a
  right_inv : (b : B) -> toFun (invFun b) = b
