-- Source: chapters/ch23_lossy_migration.tex:119

/-- ミドルネームを含む旧データ。 -/
def oldWithMiddle : UserV1 :=
  { id := 42,
    fullName :=
      { first := "Ada",
        middle := some "Byron",
        last := "Lovelace" } }

#eval migrate oldWithMiddle
#eval rollback (migrate oldWithMiddle)

/-- この具体例では、旧データへ完全には戻らない。 -/
theorem oldWithMiddle_not_restored :
    rollback (migrate oldWithMiddle) ≠ oldWithMiddle := by
  decide

/-- 強い仕様：すべての旧データについて完全に戻る。 -/
def StrongRoundTrip : Prop :=
  ∀ u : UserV1, rollback (migrate u) = u

/-- 強い仕様は、この移行では成り立たない。 -/
theorem strong_spec_fails : ¬ StrongRoundTrip := by
  intro h
  exact oldWithMiddle_not_restored (h oldWithMiddle)
