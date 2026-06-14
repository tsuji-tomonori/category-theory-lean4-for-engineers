-- Source: chapters/app_c_property_patterns.tex:497

def IsEven (n : Nat) : Prop :=
  n % 2 = 0

def ensureEven (n : Nat) : Option Nat :=
  if n % 2 = 0 then some n else none

theorem ensureEven_post (n out : Nat) :
    ensureEven n = some out -> IsEven out := by
  unfold ensureEven IsEven
  by_cases h : n % 2 = 0
  · intro hSome
    simp [h] at hSome
    cases hSome
    exact h
  · intro hSome
    simp [h] at hSome
