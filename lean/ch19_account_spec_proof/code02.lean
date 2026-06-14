-- Source: chapters/ch19_account_spec_proof.tex:126

def deposit (a : Account) (amount : Amount) : Account :=
  { a with balance := a.balance + amount }

def withdraw? (a : Account) (amount : Amount) : Option Account :=
  if amount <= a.balance then
    some { a with balance := a.balance - amount }
  else
    none

def totalBalance (a b : Account) : Balance :=
  a.balance + b.balance

def transfer? (src to : Account) (amount : Amount) : Option (Account × Account) :=
  match withdraw? src amount with
  | none => none
  | some src' => some (src', deposit to amount)
