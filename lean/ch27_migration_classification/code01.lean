-- 出典: chapters/ch21_migration_classification.tex:102
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch21MigrationClassification

structure EquivLike (A B : Type) where
  toFun : A -> B
  invFun : B -> A
  left_inv : (a : A) -> invFun (toFun a) = a
  right_inv : (b : B) -> toFun (invFun b) = b
