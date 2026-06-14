-- Source: chapters/appA_lean4_min_cheatsheet.tex:89

structure UserV1 where
  id : Nat
  name : String

structure UserV2 where
  userId : Nat
  displayName : String

def migrateUser (u : UserV1) : UserV2 :=
  { userId := u.id, displayName := u.name }

def rollbackUser (u : UserV2) : UserV1 :=
  { id := u.userId, name := u.displayName }
