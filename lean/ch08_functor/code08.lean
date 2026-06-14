-- 出典: chapters/ch08_functor.tex:334
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter08

def addOne (n : Nat) : Nat :=
  n + 1

def isEven (n : Nat) : Bool :=
  n % 2 == 0

theorem list_map_id {A : Type} (xs : List A) :
    List.map (fun x => x) xs = xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

theorem list_map_comp {A B C : Type}
    (f : A -> B) (g : B -> C) (xs : List A) :
    List.map g (List.map f xs) =
      List.map (fun x => g (f x)) xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

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

inductive Result (E : Type) (A : Type) where
  | ok : A -> Result E A
  | error : E -> Result E A

def Result.map {E A B : Type}
    (f : A -> B) : Result E A -> Result E B
  | Result.ok a => Result.ok (f a)
  | Result.error e => Result.error e

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

def migrateUsers (users : List UserV1) : List UserV2 :=
  List.map migrateUser users

#eval migrateUsers [
  { id := 1, name := "Ada" },
  { id := 2, name := "Grace" }
]
