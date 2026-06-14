-- Source: chapters/ch06_isomorphism.tex:281
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def migrate (u : UserV1) : UserV2 :=
  { userId := u.id
    contact := { email := u.email }
    profile := { displayName := u.displayName } }

def rollback (v : UserV2) : UserV1 :=
  { id := v.userId
    email := v.contact.email
    displayName := v.profile.displayName }
