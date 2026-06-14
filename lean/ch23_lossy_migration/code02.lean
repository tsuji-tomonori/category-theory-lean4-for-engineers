-- Source: chapters/ch23_lossy_migration.tex:101

/-- 新形式から旧形式へ戻し、再び新形式へ移す方向は常に戻る。 -/
theorem new_round_trip (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk id firstName lastName =>
      rfl
