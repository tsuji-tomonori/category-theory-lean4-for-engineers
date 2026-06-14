-- Source: chapters/ch14_induction.tex:316

theorem migrateUsers_preserves_ids (xs : List UserV1) :
    idsV2 (migrateUsers xs) = idsV1 xs := by
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [migrateUsers, idsV1, idsV2, migrateUser, ih]

inductive Tree (α : Type) where
  | leaf : Tree α
  | node : Tree α → α → Tree α → Tree α
  deriving Repr

namespace Tree

def map {α β : Type} (f : α → β) : Tree α → Tree β
  | Tree.leaf => Tree.leaf
  | Tree.node l x r => Tree.node (map f l) (f x) (map f r)

def size {α : Type} : Tree α → Nat
  | Tree.leaf => 0
  | Tree.node l _ r => 1 + size l + size r
