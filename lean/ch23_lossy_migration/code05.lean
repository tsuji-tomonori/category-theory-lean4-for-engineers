-- Source: chapters/ch23_lossy_migration.tex:206

/-- well-formed 条件。このモデルでは「ミドルネームがない」こと。 -/
def NoMiddle (u : UserV1) : Prop :=
  u.fullName.middle = none

/-- 条件付き仕様：well-formed な旧データなら完全に戻る。 -/
theorem rollback_after_migrate_if_no_middle
    (u : UserV1) (h : NoMiddle u) :
    rollback (migrate u) = u := by
  cases u with
  | mk id fullName =>
      cases fullName with
      | mk first middle last =>
          simp [NoMiddle] at h
          cases h
          rfl
