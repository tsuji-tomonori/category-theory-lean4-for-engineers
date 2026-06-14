-- Source: chapters/appD_migration_proof_checklist.tex:477

theorem old_roundtrip (x : Old) :
    rollback (migrate x) = x := by
  sorry

theorem old_observation_preserved (x : Old) :
    observeNew (migrate x) = observeOld x := by
  sorry
