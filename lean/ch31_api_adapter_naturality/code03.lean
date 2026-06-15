-- 出典: chapters/ch25_api_adapter_naturality.tex:146
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter25

structure OldResponse (A : Type) where
  status : Nat
  body : Option A
  requestId : String

structure NewResponse (A : Type) where
  code : Nat
  data : Option A
  requestId : String
  cached : Bool

namespace OldResponse

def map {A B : Type} (f : A -> B) (r : OldResponse A) : OldResponse B :=
  { status := r.status,
    body := Option.map f r.body,
    requestId := r.requestId }

end OldResponse

namespace NewResponse

def map {A B : Type} (f : A -> B) (r : NewResponse A) : NewResponse B :=
  { code := r.code,
    data := Option.map f r.data,
    requestId := r.requestId,
    cached := r.cached }

end NewResponse

def adapt {A : Type} (r : OldResponse A) : NewResponse A :=
  { code := r.status,
    data := r.body,
    requestId := r.requestId,
    cached := false }
