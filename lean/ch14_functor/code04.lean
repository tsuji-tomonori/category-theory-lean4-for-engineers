-- 出典: chapters/ch14_functor.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter14

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
