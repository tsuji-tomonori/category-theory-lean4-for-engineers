-- Source: chapters/ch11_monad.tex:224

def requireEmail (u : UserDraft) : Option UserWithEmail :=
  match u.emailOpt with
  | none => none
  | some email => some { id := u.id, email := email, ageOpt := u.ageOpt }

def requireAge (u : UserWithEmail) : Option UserV2 :=
  match u.ageOpt with
  | none => none
  | some age => some { id := u.id, email := u.email, age := age }

def migrateUser (u : UserDraft) : Option UserV2 :=
  optBind (requireEmail u) requireAge
