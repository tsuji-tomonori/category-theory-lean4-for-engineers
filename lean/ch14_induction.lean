namespace Ch14

structure UserV1 where
  id : Nat
  name : String
  deriving Repr, BEq

structure UserV2 where
  id : Nat
  displayName : String
  deriving Repr, BEq

def migrateUser (u : UserV1) : UserV2 :=
  { id := u.id, displayName := u.name }

def migrateUsers (xs : List UserV1) : List UserV2 :=
  xs.map migrateUser

def idsV1 (xs : List UserV1) : List Nat :=
  xs.map (fun u => u.id)

def idsV2 (xs : List UserV2) : List Nat :=
  xs.map (fun u => u.id)

theorem migrateUser_preserves_id (u : UserV1) :
    (migrateUser u).id = u.id := by
  rfl

theorem map_preserves_length {α β : Type} (f : α → β) :
    ∀ xs : List α, (xs.map f).length = xs.length := by
  intro xs
  induction xs with
  | nil =>
      rfl
  | cons x xs ih =>
      simp [List.map, ih]

theorem migrateUsers_preserves_length (xs : List UserV1) :
    (migrateUsers xs).length = xs.length := by
  simpa [migrateUsers] using map_preserves_length migrateUser xs

theorem append_length {α : Type} :
    ∀ xs ys : List α, (xs ++ ys).length = xs.length + ys.length := by
  intro xs ys
  induction xs with
  | nil =>
      simp
  | cons x xs ih =>
      simp [List.append, ih]

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

end Tree

def migrateUserTree (t : Tree UserV1) : Tree UserV2 :=
  Tree.map migrateUser t

theorem tree_map_preserves_size {α β : Type} (f : α → β) :
    ∀ t : Tree α, Tree.size (Tree.map f t) = Tree.size t := by
  intro t
  induction t with
  | leaf =>
      rfl
  | node l x r ihL ihR =>
      simp [Tree.map, Tree.size, ihL, ihR]

theorem migrateUserTree_preserves_size (t : Tree UserV1) :
    Tree.size (migrateUserTree t) = Tree.size t := by
  simpa [migrateUserTree] using tree_map_preserves_size migrateUser t

end Ch14
