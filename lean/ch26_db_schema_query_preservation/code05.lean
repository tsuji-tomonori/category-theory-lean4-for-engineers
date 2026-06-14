-- Source: chapters/ch26_db_schema_query_preservation.tex:339

/-- 読み取り用の小さなサンプル。 -/
def sampleOld : DBV1 :=
  [ { orderId := 1001, userId := 10,
      userName := "Ada", amount := 120 },
    { orderId := 1002, userId := 20,
      userName := "Grace", amount := 250 } ]

#eval queryOld sampleOld
#eval queryNew (migrateDB sampleOld)


end Ch26
