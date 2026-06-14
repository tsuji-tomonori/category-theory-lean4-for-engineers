-- Source: chapters/app_c_property_patterns.tex:139

inductive Status where
  | draft
  | active
  | archived
  | deleted

def normalizeStatus : Status -> Status
  | Status.deleted => Status.archived
  | s => s

theorem normalizeStatus_idempotent (s : Status) :
    normalizeStatus (normalizeStatus s) = normalizeStatus s := by
  cases s <;> rfl
