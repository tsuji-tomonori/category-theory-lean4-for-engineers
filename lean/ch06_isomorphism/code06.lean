-- Source: chapters/ch06_isomorphism.tex:301
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

theorem rollback_migrate (u : UserV1) :
    rollback (migrate u) = u := by
  cases u
  rfl

theorem migrate_rollback (v : UserV2) :
    migrate (rollback v) = v := by
  cases v with
  | mk userId contact profile =>
    cases contact with
    | mk email =>
      cases profile with
      | mk displayName =>
        rfl
