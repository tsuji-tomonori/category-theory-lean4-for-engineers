-- 出典: chapters/ch33_composable_design.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter33

variable {A B C D : Type}

theorem left_id_point (f : A -> B) (x : A) :
    (Function.comp id f) x = f x := by
  rfl

theorem right_id_point (f : A -> B) (x : A) :
    (Function.comp f id) x = f x := by
  rfl

theorem assoc_point
    (f : A -> B) (g : B -> C) (h : C -> D) (x : A) :
    (Function.comp h (Function.comp g f)) x =
      (Function.comp (Function.comp h g) f) x := by
  rfl

end Chapter33

namespace Ch33ETL

structure RawRow where
  userId : Nat
  rawAmount : Nat
  deriving Repr, DecidableEq

structure ValidRow where
  userId : Nat
  amount : Nat
  deriving Repr, DecidableEq

structure EnrichedRow where
  userId : Nat
  amount : Nat
  fee : Nat
  deriving Repr, DecidableEq

structure ReportRow where
  userId : Nat
  total : Nat
  deriving Repr, DecidableEq
