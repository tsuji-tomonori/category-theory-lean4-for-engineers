-- 出典: chapters/ch10_monoids_monoidal.tex:192
-- このファイルは単独でコンパイルできるよう、必要な前提定義を含む。

namespace Chapter10

abbrev Log := List String

def emptyLog : Log := []

def combineLog (a b : Log) : Log :=
  a ++ b

#eval combineLog ["start"] ["end"]

theorem combineLog_empty_left (xs : Log) :
    combineLog emptyLog xs = xs := by
  rfl

theorem combineLog_empty_right (xs : Log) :
    combineLog xs emptyLog = xs := by
  simpa [combineLog, emptyLog] using List.append_nil xs

theorem combineLog_assoc (a b c : Log) :
    combineLog (combineLog a b) c = combineLog a (combineLog b c) := by
  simpa [combineLog] using List.append_assoc a b c
