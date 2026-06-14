-- Source: chapters/ch06_isomorphism.tex:326
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def userIso : Iso UserV1 UserV2 where
  toFun := migrate
  invFun := rollback
  left_inv := rollback_migrate
  right_inv := migrate_rollback
