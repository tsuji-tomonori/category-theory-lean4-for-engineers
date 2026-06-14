-- Source: chapters/ch08_functor.tex:334

-- 一件の移行をリスト全体へ持ち上げる。
def migrateUsers (users : List UserV1) : List UserV2 :=
  List.map migrateUser users

#eval migrateUsers [
  { id := 1, name := "Ada" },
  { id := 2, name := "Grace" }
]
