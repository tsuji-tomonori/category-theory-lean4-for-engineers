-- Source: chapters/ch22_user_schema_lossless_migration.tex:219

-- 新スキーマから旧スキーマへ戻す。
def rollback (v : UserV2) : UserV1 :=
  { id := v.userId
    name := v.profile.displayName
    email := v.contact.emailAddress
    emailVerified := v.contact.verified
    createdAt := v.audit.createdAt }
