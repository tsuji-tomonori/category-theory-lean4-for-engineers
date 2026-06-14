-- Source: chapters/ch30_team_operations.tex:228

/-- Metadata connecting a theorem to a spec and implementation file. -/
structure ModelLink where
  specId : Nat
  theoremName : String
  modelFile : String
  implementationFile : String
  assumption : String

/-- Example metadata for a user migration proof. -/
def userMigrationLink : ModelLink :=
  { specId := 2204
    theoremName := "rollback_migrate_user_v1"
    modelFile := "Verification/UserMigration.lean"
    implementationFile := "src/user_migration.ts"
    assumption := "Lean model ignores database IO and timestamps" }

#eval userMigrationLink.theoremName


end Chapter30
