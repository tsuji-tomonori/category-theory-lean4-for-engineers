-- Source: chapters/ch14_induction.tex:372
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def migrateUserTree (t : Tree UserV1) : Tree UserV2 :=
  Tree.map migrateUser t

theorem migrateUserTree_preserves_size (t : Tree UserV1) :
    Tree.size (migrateUserTree t) = Tree.size t := by
  simpa [migrateUserTree] using tree_map_preserves_size migrateUser t
