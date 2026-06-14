-- Source: chapters/ch24_list_migration_functor_laws.tex:273

structure UserV3 where
  accountId : Nat
  displayName : String
  canLogin : Bool
deriving Repr, DecidableEq

def normalize (v : UserV2) : UserV3 :=
  { accountId := v.userId,
    displayName := v.profileName,
    canLogin := v.enabled }

def migrateThenNormalize (u : UserV1) : UserV3 :=
  normalize (migrate u)

def migrateAllThenNormalize (xs : List UserV1) : List UserV3 :=
  xs.map migrateThenNormalize

def normalizeAfterMigrateAll (xs : List UserV1) : List UserV3 :=
  (migrateAll xs).map normalize

theorem migrateAll_composition (xs : List UserV1) :
    migrateAllThenNormalize xs = normalizeAfterMigrateAll xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateAllThenNormalize, normalizeAfterMigrateAll,
        migrateThenNormalize, migrateAll, ih]
