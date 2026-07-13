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
