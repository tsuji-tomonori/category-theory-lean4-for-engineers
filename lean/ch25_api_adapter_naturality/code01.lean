-- 出典: chapters/ch25_api_adapter_naturality.tex:79
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
