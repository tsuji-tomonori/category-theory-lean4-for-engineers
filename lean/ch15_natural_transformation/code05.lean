-- 出典: chapters/ch15_natural_transformation.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter15

def optionMap {A B : Type} (f : A -> B) : Option A -> Option B
  | none => none
  | some a => some (f a)

def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

#eval optionToList (some 10)
#eval optionToList (none : Option Nat)

theorem optionToList_naturality {A B : Type}
    (f : A -> B) (x : Option A) :
    optionToList (optionMap f x) =
      List.map f (optionToList x) := by
  cases x <;> rfl

structure NatTransOptionList where
  app : {A : Type} -> Option A -> List A
  naturality :
    {A B : Type} -> (f : A -> B) -> (x : Option A) ->
      app (optionMap f x) = List.map f (app x)

def optionToListNT : NatTransOptionList where
  app := fun x => optionToList x
  naturality := by
    intro A B f x
    cases x <;> rfl

inductive Status where
  | ok
  | empty
  deriving Repr, DecidableEq

structure OldResponse (A : Type) where
  traceId : Nat
  payload : Option A
  deriving Repr

structure NewResponse (A : Type) where
  traceId : Nat
  status : Status
  items : List A
  deriving Repr

def statusOf {A : Type} : Option A -> Status
  | none => Status.empty
  | some _ => Status.ok

def oldMap {A B : Type} (f : A -> B)
    (r : OldResponse A) : OldResponse B :=
  { traceId := r.traceId,
    payload := optionMap f r.payload }

def newMap {A B : Type} (f : A -> B)
    (r : NewResponse A) : NewResponse B :=
  { traceId := r.traceId,
    status := r.status,
    items := List.map f r.items }

def adapt {A : Type} (r : OldResponse A) : NewResponse A :=
  { traceId := r.traceId,
    status := statusOf r.payload,
    items := optionToList r.payload }

#eval adapt ({ traceId := 7, payload := some 42 } : OldResponse Nat)

theorem adapt_naturality {A B : Type}
    (f : A -> B) (r : OldResponse A) :
    adapt (oldMap f r) = newMap f (adapt r) := by
  cases r with
  | mk trace payload =>
    cases payload <;> rfl

theorem adapt_naturality_as_function_equality {A B : Type}
    (f : A -> B) :
    (fun r : OldResponse A => adapt (oldMap f r)) =
      (fun r : OldResponse A => newMap f (adapt r)) := by
  funext r
  exact adapt_naturality f r

end Chapter15
