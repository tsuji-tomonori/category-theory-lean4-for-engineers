-- Source: chapters/appD_migration_proof_checklist.tex:449

axiom Old : Type
axiom New : Type
axiom migrate : Old -> New
axiom rollback : New -> Old
axiom observeOld : Old -> Nat
axiom observeNew : New -> Nat
axiom WellFormedOld : Old -> Prop
axiom WellFormedNew : New -> Prop
axiom normalizeOld : Old -> Nat
axiom normalizeNew : New -> Nat
axiom abstract : Old -> Nat
axiom SafePublic : Nat -> Prop

theorem rollback_migrate_id (x : Old) :
    rollback (migrate x) = x := by
  sorry

theorem migrate_rollback_id (y : New) :
    migrate (rollback y) = y := by
  sorry
