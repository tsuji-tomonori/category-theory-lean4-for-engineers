-- 出典: chapters/ch02_props_specs.tex:62
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Ch02PropsSpecs

def hasDiscount (member : Bool) : Bool :=
  member

#eval hasDiscount true
#eval hasDiscount false
