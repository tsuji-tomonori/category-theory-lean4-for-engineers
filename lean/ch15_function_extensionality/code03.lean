-- Source: chapters/ch15_function_extensionality.tex:161

-- 入力をそのまま元の関数に渡すだけの wrapper。
def noopWrapper {α β : Type} (f : α → β) : α → β :=
  fun x => f x

-- wrapper を通しても、関数としては同じ。
theorem noopWrapper_eq {α β : Type} (f : α → β) :
    noopWrapper f = f := by
  funext x
  rfl
