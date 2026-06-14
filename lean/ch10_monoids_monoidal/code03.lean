-- Source: chapters/ch10_monoids_monoidal.tex:275

def planLeft (a b c : Log) : Log :=
  combineLog (combineLog a b) c

def planRight (a b c : Log) : Log :=
  combineLog a (combineLog b c)

theorem log_plan_safe (a b c : Log) :
    planLeft a b c = planRight a b c := by
  simpa [planLeft, planRight] using combineLog_assoc a b c
