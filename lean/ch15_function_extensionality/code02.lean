-- Source: chapters/ch15_function_extensionality.tex:131

-- 書き方が違うだけの関数。
def oldPlusOne (n : Nat) : Nat :=
  (fun x => x + 1) n

def newPlusOne (n : Nat) : Nat :=
  n + 1

-- 関数そのものが等しいことを示す。
theorem oldPlusOne_eq_newPlusOne :
    oldPlusOne = newPlusOne := by
  funext n
  rfl
