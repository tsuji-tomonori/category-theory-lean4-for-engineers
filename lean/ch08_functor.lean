/-
第8章 関手：構造を保ったまま中身を変える
Lean 4 examples.
-/

namespace Chapter08

-- 単体の変換。
def addOne (n : Nat) : Nat :=
  n + 1

def isEven (n : Nat) : Bool :=
  n % 2 == 0

-- List.map は恒等関数を保存する。
theorem list_map_id {A : Type} (xs : List A) :
    List.map (fun x => x) xs = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

-- List.map は合成を保存する。
theorem list_map_comp {A B C : Type}
    (f : A -> B) (g : B -> C) (xs : List A) :
    List.map g (List.map f xs) =
      List.map (fun x => g (f x)) xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

-- Option.map の関手則。
theorem option_map_id {A : Type} (x : Option A) :
    Option.map (fun a => a) x = x := by
  cases x with
  | none =>
      rfl
  | some a =>
      rfl

theorem option_map_comp {A B C : Type}
    (f : A -> B) (g : B -> C) (x : Option A) :
    Option.map g (Option.map f x) =
      Option.map (fun a => g (f a)) x := by
  cases x with
  | none =>
      rfl
  | some a =>
      rfl

-- 章内で使う小さな Result 型。
inductive Result (E : Type) (A : Type) where
  | ok : A -> Result E A
  | error : E -> Result E A

def Result.map {E A B : Type}
    (f : A -> B) : Result E A -> Result E B
  | Result.ok a => Result.ok (f a)
  | Result.error e => Result.error e

-- Result.map の関手則。
theorem result_map_id {E A : Type} (x : Result E A) :
    Result.map (fun a => a) x = x := by
  cases x with
  | ok a =>
      rfl
  | error e =>
      rfl

theorem result_map_comp {E A B C : Type}
    (f : A -> B) (g : B -> C) (x : Result E A) :
    Result.map g (Result.map f x) =
      Result.map (fun a => g (f a)) x := by
  cases x with
  | ok a =>
      rfl
  | error e =>
      rfl

-- 実務例：一件のユーザー移行。
structure UserV1 where
  id : Nat
  name : String
deriving Repr

structure UserV2 where
  userId : Nat
  displayName : String

deriving instance Repr for UserV2

def migrateUser (u : UserV1) : UserV2 :=
  { userId := u.id, displayName := u.name }

-- 一件の移行をリスト全体へ持ち上げる。
def migrateUsers (users : List UserV1) : List UserV2 :=
  List.map migrateUser users

#eval migrateUsers [
  { id := 1, name := "Ada" },
  { id := 2, name := "Grace" }
]

-- List.map はリストの長さを保存する。
theorem list_map_length {A B : Type}
    (f : A -> B) (xs : List A) :
    (List.map f xs).length = xs.length := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

theorem migrateUsers_length (users : List UserV1) :
    (migrateUsers users).length = users.length := by
  exact list_map_length migrateUser users

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
