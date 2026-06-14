-- Source: chapters/appD_migration_proof_checklist.tex:500

theorem migrate_rollback_on_wellformed
    (y : New) (h : WellFormedNew y) :
    migrate (rollback y) = y := by
  sorry

theorem migrate_preserves_wellformed
    (x : Old) (h : WellFormedOld x) :
    WellFormedNew (migrate x) := by
  sorry
