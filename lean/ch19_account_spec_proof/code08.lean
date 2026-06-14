-- Source: chapters/ch19_account_spec_proof.tex:344

def alice : Account := { id := 1, balance := 100 }
def bob : Account := { id := 2, balance := 40 }

#eval deposit alice 20
#eval withdraw? alice 30
#eval withdraw? alice 130
#eval transfer? alice bob 30


end Chapter19
