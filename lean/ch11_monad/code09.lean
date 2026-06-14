-- Source: chapters/ch11_monad.tex:381

def migrateUserExcept (u : UserDraft) : Except MigrationError UserV2 :=
  exceptBind (requireEmailE u) requireAgeE

#eval migrateUserExcept goodDraft
#eval migrateUserExcept missingEmailDraft
#eval migrateUserExcept missingAgeDraft

theorem except_left_identity {ε α β : Type} (a : α) (f : α → Except ε β) :
    exceptBind (exceptPure a) f = f a := by
  rfl

theorem except_right_identity {ε α : Type} (x : Except ε α) :
    exceptBind x exceptPure = x := by
  cases x <;> rfl

theorem except_assoc {ε α β γ : Type}
    (x : Except ε α) (f : α → Except ε β) (g : β → Except ε γ) :
    exceptBind (exceptBind x f) g =
      exceptBind x (fun a => exceptBind (f a) g) := by
  cases x <;> rfl

/-! ## 状態を持つ計算の最小モデル -/

abbrev SimpleState (σ α : Type) := σ → (α × σ)

def statePure {σ α : Type} (a : α) : SimpleState σ α :=
  fun s => (a, s)

def stateBind {σ α β : Type}
    (m : SimpleState σ α) (f : α → SimpleState σ β) : SimpleState σ β :=
  fun s =>
    let r := m s
    f r.fst r.snd
