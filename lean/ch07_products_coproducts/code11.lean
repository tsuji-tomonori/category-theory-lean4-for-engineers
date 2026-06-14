-- Source: chapters/ch07_products_coproducts.tex:366
-- check-lean-snippets: skip
-- Repeated in the chapter text for explanation; omitted from chapter-level Lean check.

inductive ApiError where
  | notFound
  | invalidInput

structure ResponseBody where
  status : Nat
  body   : String

abbrev ApiResponse := Sum ApiError ResponseBody

def handleResponse {C : Type}
    (onError : ApiError → C)
    (onOk : ResponseBody → C)
    (r : ApiResponse) : C :=
  eitherElim onError onOk r

theorem handleResponse_ok (onError : ApiError → String)
    (onOk : ResponseBody → String) (body : ResponseBody) :
    handleResponse onError onOk (Sum.inr body) = onOk body := rfl
