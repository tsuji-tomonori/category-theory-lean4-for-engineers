-- Source: chapters/ch11_monad.tex:345
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

def exceptBind {ε α β : Type}
    (x : Except ε α) (f : α → Except ε β) : Except ε β :=
  match x with
  | Except.error e => Except.error e
  | Except.ok a => f a

theorem except_right_identity {ε α : Type} (x : Except ε α) :
    exceptBind x exceptPure = x := by
  cases x <;> rfl

theorem except_assoc {ε α β γ : Type}
    (x : Except ε α) (f : α → Except ε β) (g : β → Except ε γ) :
    exceptBind (exceptBind x f) g =
      exceptBind x (fun a => exceptBind (f a) g) := by
  cases x <;> rfl
