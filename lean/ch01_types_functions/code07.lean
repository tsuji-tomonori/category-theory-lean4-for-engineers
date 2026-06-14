-- Source: chapters/ch01_types_functions.tex:469

def nonempty (s : String) : Option String :=
  if s == "" then none else some s

def decorate (s : String) : String :=
  mark (surround s)

def decorateIfNonempty (s : String) : Option String :=
  match nonempty s with
  | none => none
  | some value => some (decorate value)

def decorateAll (xs : List String) : List (Option String) :=
  xs.map decorateIfNonempty

#eval decorateIfNonempty ""
#eval decorateIfNonempty "lean"
#eval decorateAll ["a", "", "b"]
