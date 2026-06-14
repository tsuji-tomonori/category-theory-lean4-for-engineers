-- Source: chapters/appB_category_cheatsheet.tex:309

def idFn (A : Type) : A -> A := fun x => x

def comp {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)

theorem comp_assoc {A B C D : Type}
    (h : C -> D) (g : B -> C) (f : A -> B) :
    comp h (comp g f) = comp (comp h g) f := by
  rfl

structure Iso (A B : Type) where
  toFun : A -> B
  invFun : B -> A
  left_inv : forall a : A, invFun (toFun a) = a
  right_inv : forall b : B, toFun (invFun b) = b

def optionToList {A : Type} : Option A -> List A
  | none => []
  | some a => [a]

theorem optionToList_natural {A B : Type}
    (f : A -> B) (x : Option A) :
    optionToList (Option.map f x) = List.map f (optionToList x) := by
  cases x <;> rfl
