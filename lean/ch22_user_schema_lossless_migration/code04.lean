-- Source: chapters/ch22_user_schema_lossless_migration.tex:263

-- 旧データを新形式へ移し、旧形式へ戻すと元に戻る。
theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl
