-- Source: chapters/appA_lean4_min_cheatsheet.tex:117

def sameIdAfterMigrate (u : UserV1) : Nat :=
  (migrateUser u).userId
