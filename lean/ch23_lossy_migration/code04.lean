-- Source: chapters/ch23_lossy_migration.tex:160

/-- 旧データを公開表示用に正規化する。ミドルネームは表示しない方針にする。 -/
def canonicalDisplayV1 (u : UserV1) : String :=
  u.fullName.first ++ " " ++ u.fullName.last

/-- 新データの表示。 -/
def displayV2 (v : UserV2) : String :=
  v.firstName ++ " " ++ v.lastName

/-- 弱い仕様：完全復元ではなく、公開表示が一致することだけを要求する。 -/
def WeakDisplaySpec : Prop :=
  ∀ u : UserV1, displayV2 (migrate u) = canonicalDisplayV1 u

/-- 弱い仕様は全旧データについて成り立つ。 -/
theorem weak_display_spec_holds : WeakDisplaySpec := by
  intro u
  rfl
