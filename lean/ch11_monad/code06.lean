-- Source: chapters/ch11_monad.tex:279
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def migrateUserDo (u : UserDraft) : Option UserV2 := do
  let withEmail ← requireEmail u
  requireAge withEmail

theorem migrateUser_refactor (u : UserDraft) :
    migrateUser u = migrateUserDo u := by
  cases u with
  | mk id emailOpt ageOpt =>
      cases emailOpt <;> cases ageOpt <;> rfl
