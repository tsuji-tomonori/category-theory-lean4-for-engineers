-- Source: chapters/ch05_category.tex:377

-- 何もしない文字列処理。
def noOpString : String -> String :=
  idFn

-- no-op を最後に挟んだパイプライン。
def pipelineWithNoOp : String -> String :=
  comp noOpString pipelineLeft

-- 任意の入力で、no-op ありと no-op なしの結果は一致する。
theorem remove_noop_pointwise (s : String) :
    pipelineWithNoOp s = pipelineLeft s := by
  rfl


end Ch05Category
