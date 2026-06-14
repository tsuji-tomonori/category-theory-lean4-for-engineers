-- Source: chapters/ch10_monoids_monoidal.tex:339

theorem mergeConfig_assoc (a b c : Config) :
    mergeConfig (mergeConfig a b) c =
    mergeConfig a (mergeConfig b c) := by
  cases a
  cases b
  cases c
  simp [mergeConfig, Nat.add_assoc, List.append_assoc]


end Chapter10
