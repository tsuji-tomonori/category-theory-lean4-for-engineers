-- 出典: chapters/ch31_api_adapter_naturality.tex（対応する本文コードブロック）
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter31

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
