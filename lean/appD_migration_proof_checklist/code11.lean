-- Source: chapters/appD_migration_proof_checklist.tex:527

theorem normalized_observation_preserved (x : Old) :
    normalizeNew (migrate x) = normalizeOld x := by
  sorry

theorem abstraction_is_safe (x : Old) :
    SafePublic (abstract x) := by
  sorry
