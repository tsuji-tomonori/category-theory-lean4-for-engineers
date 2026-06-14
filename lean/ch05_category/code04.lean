-- Source: chapters/ch05_category.tex:344

-- 点ごとに見ると、両方のパイプラインは同じ式へ展開される。
theorem pipeline_assoc_pointwise (s : String) :
    pipelineLeft s = pipelineRight s := by
  rfl

-- calc を使うと、レビュー用の変形ログとして読める。
theorem pipeline_review_log (s : String) :
    pipelineLeft s = pipelineRight s := by
  calc
    pipelineLeft s
        = renderGreeting (fetchUserName (parseUserId s)) := by rfl
    _   = pipelineRight s := by rfl
