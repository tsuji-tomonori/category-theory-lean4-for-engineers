-- 出典: chapters/ch07_variables_and_forall.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

def surround (s : String) : String :=
  "[" ++ s ++ "]"

def nonempty (s : String) : Option String :=
  if s == "" then none else some s

def decorateIfNonempty (s : String) : Option String :=
  match nonempty s with
  | none => none
  | some value => some (surround value)

def decorateAll (xs : List String) : List (Option String) :=
  xs.map decorateIfNonempty

#eval decorateIfNonempty ""
#eval decorateIfNonempty "lean"
#eval decorateAll ["a", "", "b"]
