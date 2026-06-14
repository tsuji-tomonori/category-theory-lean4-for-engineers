-- Source: chapters/ch10_monoids_monoidal.tex:303

structure Config where
  retry : Nat
  tags : List String
  deriving Repr

def emptyConfig : Config :=
  { retry := 0, tags := [] }

def mergeConfig (a b : Config) : Config :=
  { retry := a.retry + b.retry,
    tags := a.tags ++ b.tags }

#eval mergeConfig { retry := 1, tags := ["api"] }
                  { retry := 2, tags := ["db"] }

theorem mergeConfig_empty_left (c : Config) :
    mergeConfig emptyConfig c = c := by
  cases c
  simp [mergeConfig, emptyConfig]

theorem mergeConfig_empty_right (c : Config) :
    mergeConfig c emptyConfig = c := by
  cases c
  simp [mergeConfig, emptyConfig]
