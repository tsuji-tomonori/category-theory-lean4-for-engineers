-- 出典: chapters/ch15_function_extensionality.tex:329
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch15

def pointwiseEq {α β : Type} (f g : α → β) : Prop :=
  ∀ x : α, f x = g x

theorem funext_from_pointwise
    {α β : Type} {f g : α → β}
    (h : pointwiseEq f g) : f = g := by
  funext x
  exact h x

def oldPlusOne (n : Nat) : Nat :=
  (fun x => x + 1) n

def newPlusOne (n : Nat) : Nat :=
  n + 1

theorem oldPlusOne_eq_newPlusOne :
    oldPlusOne = newPlusOne := by
  funext n
  rfl

def noopWrapper {α β : Type} (f : α → β) : α → β :=
  fun x => f x

theorem noopWrapper_eq {α β : Type} (f : α → β) :
    noopWrapper f = f := by
  funext x
  rfl

theorem apply_pointwise
    {α β : Type} {f g : α → β}
    (h : ∀ x : α, f x = g x) (x : α) :
    f x = g x := by
  exact h x

theorem function_eq_to_pointwise
    {α β : Type} {f g : α → β}
    (h : f = g) :
    ∀ x : α, f x = g x := by
  intro x
  rw [h]

structure Request where
  userId : Nat
  amount : Nat
deriving Repr

structure Response where
  status : Nat
  value : Nat
deriving Repr

def clientV1 (r : Request) : Response :=
  { status := 200, value := r.amount + 1 }

def clientV2 (r : Request) : Response :=
  let calculated := r.amount + 1
  { status := 200, value := calculated }

#eval clientV1 { userId := 1, amount := 100 }

theorem clientV1_eq_clientV2 :
    clientV1 = clientV2 := by
  funext r
  rfl

def addDefaultHeader
    (client : Request → Response) : Request → Response :=
  fun r => client r

def recordMetrics
    (client : Request → Response) : Request → Response :=
  fun r => client r

theorem wrapper_order_eq (client : Request → Response) :
    addDefaultHeader (recordMetrics client)
      = recordMetrics (addDefaultHeader client) := by
  funext r
  rfl

def clientWithFallback
    (client : Request → Option Response) : Request → Option Response :=
  fun r =>
    match client r with
    | some res => some res
    | none => none

theorem clientWithFallback_eq
    (client : Request → Option Response) :
    clientWithFallback client = client := by
  funext r
  cases h : client r <;> simp [clientWithFallback, h]

end Ch15
