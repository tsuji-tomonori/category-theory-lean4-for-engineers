-- Source: chapters/ch22_user_schema_lossless_migration.tex:281

-- 新データを旧形式へ戻し、再び新形式へ移すと元に戻る。
theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk userId profile contact audit =>
    cases profile with
    | mk displayName =>
      cases contact with
      | mk emailAddress verified =>
        cases audit with
        | mk createdAt =>
          rfl
