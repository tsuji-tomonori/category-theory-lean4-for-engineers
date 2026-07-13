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

def sanitize (r : RawRow) : ValidRow :=
  { userId := r.userId, amount := r.rawAmount }

def enrich (r : ValidRow) : EnrichedRow :=
  { userId := r.userId, amount := r.amount, fee := 10 }

def summarize (r : EnrichedRow) : ReportRow :=
  { userId := r.userId, total := r.amount + r.fee }

def pipeline : RawRow -> ReportRow :=
  Function.comp summarize (Function.comp enrich sanitize)

def pipelineExpanded (r : RawRow) : ReportRow :=
  summarize (enrich (sanitize r))

theorem pipeline_same_as_expanded (r : RawRow) :
    pipeline r = pipelineExpanded r := by
  rfl

def pipelineWithIdentity (r : RawRow) : ReportRow :=
  summarize ((fun x => x) (enrich (sanitize r)))

theorem identity_step_removed (r : RawRow) :
    pipelineWithIdentity r = pipeline r := by
  rfl

theorem pipeline_assoc (r : RawRow) :
    (Function.comp summarize (Function.comp enrich sanitize)) r =
      (Function.comp (Function.comp summarize enrich) sanitize) r := by
  rfl

end Ch33ETL

namespace Ch33Stage

structure Stage (A B : Type) where
  run : A -> B

namespace Stage

variable {A B C D : Type}

def id (A : Type) : Stage A A :=
  { run := fun x => x }

def andThen (s1 : Stage A B) (s2 : Stage B C) : Stage A C :=
  { run := Function.comp s2.run s1.run }

theorem left_id (s : Stage A B) (x : A) :
    ((id A).andThen s).run x = s.run x := by
  rfl
