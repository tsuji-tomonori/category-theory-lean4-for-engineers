-- 出典: chapters/ch11_category.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter11

def idFn {A : Type} (x : A) : A :=
  x

def comp {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)

theorem id_left_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp idFn f x = f x := by
  rfl

theorem id_right_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp f idFn x = f x := by
  rfl

theorem comp_assoc_pointwise {A B C D : Type}
    (h : C -> D) (g : B -> C) (f : A -> B) (x : A) :
    comp (comp h g) f x = comp h (comp g f) x := by
  rfl

def parseUserId (s : String) : Nat :=
  s.length

def fetchUserName (id : Nat) : String :=
  "user-" ++ toString id

def renderGreeting (name : String) : String :=
  "hello, " ++ name

def pipelineLeft : String -> String :=
  comp (comp renderGreeting fetchUserName) parseUserId

def pipelineRight : String -> String :=
  comp renderGreeting (comp fetchUserName parseUserId)

#eval pipelineLeft "abc"

theorem pipeline_assoc_pointwise (s : String) :
    pipelineLeft s = pipelineRight s := by
  rfl

theorem pipeline_review_log (s : String) :
    pipelineLeft s = pipelineRight s := by
  calc
    pipelineLeft s
        = renderGreeting (fetchUserName (parseUserId s)) := by rfl
    _   = pipelineRight s := by rfl
