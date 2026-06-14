-- Source: chapters/ch22_user_schema_lossless_migration.tex:178

-- 旧スキーマから新スキーマへ移す。
def migrate (u : UserV1) : UserV2 :=
  { userId := u.id
    profile := { displayName := u.name }
    contact :=
      { emailAddress := u.email
        verified := u.emailVerified }
    audit := { createdAt := u.createdAt } }

#eval migrate
  { id := 1
    name := "Ada"
    email := "ada@example.com"
    emailVerified := true
    createdAt := 1000 }
