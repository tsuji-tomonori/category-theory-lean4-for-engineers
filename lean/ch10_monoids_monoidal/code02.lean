-- Source: chapters/ch10_monoids_monoidal.tex:231

structure SimpleMonoid (M : Type) where
  empty : M
  append : M -> M -> M
  empty_left : forall x, append empty x = x
  empty_right : forall x, append x empty = x
  append_assoc : forall x y z,
    append (append x y) z = append x (append y z)

-- List Nat は、空リストとリスト連結でモノイドになる。
def listNatMonoid : SimpleMonoid (List Nat) where
  empty := []
  append := fun xs ys => xs ++ ys
  empty_left := by
    intro xs
    rfl
  empty_right := by
    intro xs
    simpa using List.append_nil xs
  append_assoc := by
    intro xs ys zs
    simpa using List.append_assoc xs ys zs
