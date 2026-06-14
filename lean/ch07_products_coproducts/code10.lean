-- Source: chapters/ch07_products_coproducts.tex:350

inductive ApiError where
  | notFound
  | invalidInput

structure ResponseBody where
  status : Nat
  body   : String

structure BadResponse where
  errorCode : Nat
  body      : String


abbrev ApiResponse := Sum ApiError ResponseBody

def handleResponse {C : Type}
    (onError : ApiError → C)
    (onOk : ResponseBody → C)
    (r : ApiResponse) : C :=
  eitherElim onError onOk r

theorem handleResponse_ok (onError : ApiError → String)
    (onOk : ResponseBody → String) (body : ResponseBody) :
    handleResponse onError onOk (Sum.inr body) = onOk body := rfl

theorem handleResponse_error (onError : ApiError → String)
    (onOk : ResponseBody → String) (e : ApiError) :
    handleResponse onError onOk (Sum.inl e) = onError e := rfl

end Ch07
