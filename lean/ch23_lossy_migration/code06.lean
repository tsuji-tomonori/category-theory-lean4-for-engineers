-- Source: chapters/ch23_lossy_migration.tex:240

/-- 正規化。旧データを、新形式で表せる範囲の旧データへ丸める。 -/
def normalizeV1 (u : UserV1) : UserV1 :=
  rollback (migrate u)

/-- 正規化してから移行しても、最初に移行した結果と同じ。 -/
theorem migrate_after_normalize (u : UserV1) :
    migrate (normalizeV1 u) = migrate u := by
  cases u with
  | mk id fullName =>
      cases fullName with
      | mk first middle last =>
          rfl

/-- 正規化は一度で十分。二度かけても結果は変わらない。 -/
theorem normalize_idempotent (u : UserV1) :
    normalizeV1 (normalizeV1 u) = normalizeV1 u := by
  cases u with
  | mk id fullName =>
      cases fullName with
      | mk first middle last =>
          rfl


end Ch23
