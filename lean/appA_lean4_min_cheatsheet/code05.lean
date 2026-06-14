-- Source: chapters/appA_lean4_min_cheatsheet.tex:165

example : inc 0 = 1 := by
  rfl

theorem inc_eq_add_one (n : Nat) :
    inc n = n + 1 := by
  rfl

theorem rollback_migrate_user (u : UserV1) :
    rollbackUser (migrateUser u) = u := by
  rfl
