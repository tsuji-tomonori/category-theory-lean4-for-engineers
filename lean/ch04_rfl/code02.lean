-- 出典: chapters/ch04_rfl.tex
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。
-- 失敗例（本文ではコメントとして提示）。コンパイルを壊さないよう定義のみ残す。

def hasDiscount (member : Bool) : Bool :=
  member

-- これは証明できない（false = true になるため）
-- example : hasDiscount false = true := by
--   rfl
