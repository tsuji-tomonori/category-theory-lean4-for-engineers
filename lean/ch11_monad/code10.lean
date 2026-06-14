-- Source: chapters/ch11_monad.tex:402

def getState : SimpleState Nat Nat :=
  fun s => (s, s)

def putState (s : Nat) : SimpleState Nat Unit :=
  fun _ => ((), s)

def tick : SimpleState Nat Nat :=
  stateBind getState (fun n =>
    stateBind (putState (n + 1)) (fun _ =>
      statePure n))

def twoTicks : SimpleState Nat (Nat × Nat) :=
  stateBind tick (fun first =>
    stateBind tick (fun second =>
      statePure (first, second)))

#eval tick 10

#eval twoTicks 10

theorem state_left_identity_pointwise {σ α β : Type}
    (a : α) (f : α → SimpleState σ β) (s : σ) :
    stateBind (statePure a) f s = f a s := by
  rfl

end Chapter11Monad
