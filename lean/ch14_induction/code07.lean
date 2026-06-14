-- Source: chapters/ch14_induction.tex:348

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
