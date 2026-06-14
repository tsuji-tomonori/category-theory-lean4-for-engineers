-- Source: chapters/ch21_migration_classification.tex:260
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def IsDefaultIssuedAt (n : NewToken) : Prop :=
  n.issuedAt = 0

theorem new_roundtrip_when_default
    (n : NewToken) (h : IsDefaultIssuedAt n) :
    oldToNew (newToOld n) = n := by
  cases n with
  | mk token issuedAt =>
      unfold IsDefaultIssuedAt at h
      simp at h
      cases h
      rfl
