-- Source: chapters/ch11_monad.tex:247

def migrateUserDo (u : UserDraft) : Option UserV2 := do
  let withEmail ← requireEmail u
  requireAge withEmail

def goodDraft : UserDraft :=
  { id := 7, emailOpt := some "a@example.com", ageOpt := some 20 }

def missingEmailDraft : UserDraft :=
  { id := 8, emailOpt := none, ageOpt := some 20 }

def missingAgeDraft : UserDraft :=
  { id := 9, emailOpt := some "b@example.com", ageOpt := none }

#eval migrateUser goodDraft
#eval migrateUser missingEmailDraft
#eval migrateUser missingAgeDraft
