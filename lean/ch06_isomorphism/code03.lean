-- Source: chapters/ch06_isomorphism.tex:222
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

namespace Iso

def refl (A : Type u) : Iso A A where
  toFun := fun a => a
  invFun := fun a => a
  left_inv := by
    intro a
    rfl
  right_inv := by
    intro a
    rfl

end Iso
