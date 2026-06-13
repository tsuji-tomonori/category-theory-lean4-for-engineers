/-
Chapter 15: Function extensionality.
This file contains the Lean snippets used in
chapters/ch15_function_extensionality.tex.
-/

namespace Ch15

-- 点ごとの一致を、名前を付けて読みやすくする。
def pointwiseEq {α β : Type} (f g : α → β) : Prop :=
  ∀ x : α, f x = g x

-- すべての入力で同じなら、関数そのものも等しい。
theorem funext_from_pointwise
    {α β : Type} {f g : α → β}
    (h : pointwiseEq f g) : f = g := by
  funext x
  exact h x

-- 書き方が違うだけの関数。
def oldPlusOne (n : Nat) : Nat :=
  (fun x => x + 1) n

def newPlusOne (n : Nat) : Nat :=
  n + 1

-- 関数そのものが等しいことを示す。
theorem oldPlusOne_eq_newPlusOne :
    oldPlusOne = newPlusOne := by
  funext n
  rfl

-- 入力をそのまま元の関数に渡すだけの wrapper。
def noopWrapper {α β : Type} (f : α → β) : α → β :=
  fun x => f x

-- wrapper を通しても、関数としては同じ。
theorem noopWrapper_eq {α β : Type} (f : α → β) :
    noopWrapper f = f := by
  funext x
  rfl

-- 点ごとの等式を、特定の入力に適用する。
theorem apply_pointwise
    {α β : Type} {f g : α → β}
    (h : ∀ x : α, f x = g x) (x : α) :
    f x = g x := by
  exact h x

-- 関数そのものの等式から、点ごとの等式を得る。
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

-- 旧 client。金額に 1 を足して返すだけの単純モデル。
def clientV1 (r : Request) : Response :=
  { status := 200, value := r.amount + 1 }

-- 新 client。補助的な let を使うが、返す値は同じ。
def clientV2 (r : Request) : Response :=
  let calculated := r.amount + 1
  { status := 200, value := calculated }

#eval clientV1 { userId := 1, amount := 100 }

-- すべての Request で同じ Response を返すので、
-- 関数としても等しい。
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
  cases client r <;> rfl

end Ch15
