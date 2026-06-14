-- Source: chapters/ch26_db_schema_query_preservation.tex:284

/-- 本章の有限 DB モデル。 -/
def DBV1 := List OrderOld

def DBV2 := List ConsistentSplitRow

/-- DB 全体を新スキーマへ移す。 -/
def migrateDB (db : DBV1) : DBV2 :=
  List.map splitOrderChecked db

/-- 旧 DB へのクエリ。 -/
def queryOld (db : DBV1) : List OrderView :=
  List.map queryOldRow db

/-- 新 DB へのクエリ。 -/
def queryNew (db : DBV2) : List OrderView :=
  List.map queryNewRow db

/-- 整合性つきにしても、一行のクエリ保存は成り立つ。 -/
theorem checked_row_preserves_query (r : OrderOld) :
    queryNewRow (splitOrderChecked r) = queryOldRow r := by
  cases r
  rfl

/--
任意の旧 DB について、移行後に新クエリを実行した結果は、
移行前に旧クエリを実行した結果と一致する。
-/
theorem query_preserved (db : DBV1) :
    queryNew (migrateDB db) = queryOld db := by
  induction db with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateDB, queryNew, queryOld,
            checked_row_preserves_query, ih]
