-- Source: chapters/ch08_functor.tex:374

-- 移行後も ID 列が保存される。
def idsV1 (users : List UserV1) : List Nat :=
  List.map UserV1.id users

def idsV2 (users : List UserV2) : List Nat :=
  List.map UserV2.userId users

theorem migrateUser_preserves_id (u : UserV1) :
    (migrateUser u).userId = u.id := by
  rfl

theorem migrateUsers_preserves_ids (users : List UserV1) :
    idsV2 (migrateUsers users) = idsV1 users := by
  simp [idsV1, idsV2, migrateUsers, migrateUser]


end Chapter08
