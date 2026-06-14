-- Source: chapters/ch22_user_schema_lossless_migration.tex:314

-- 二つの変換関数と二つの round-trip 証明をまとめる。
structure SchemaIso (A B : Type) where
  to : A -> B
  backward : B -> A
  backward_to : forall a, backward (to a) = a
  to_backward : forall b, to (backward b) = b

-- UserV1 と UserV2 は、このモデル上では同型である。
def userSchemaIso : SchemaIso UserV1 UserV2 :=
  { to := migrate
    backward := rollback
    backward_to := rollback_migrate
    to_backward := migrate_rollback }


-- 次章への橋渡し：一件の round-trip は、map でリスト全体にも使える。
def batchMigrate (users : List UserV1) : List UserV2 :=
  users.map migrate

def batchRollback (users : List UserV2) : List UserV1 :=
  users.map rollback

theorem batch_rollback_migrate (users : List UserV1) :
    batchRollback (batchMigrate users) = users := by
  induction users with
  | nil => rfl
  | cons u us ih =>
    unfold batchMigrate batchRollback at ih ⊢
    simp [rollback_migrate, ih]

end Chapter22
