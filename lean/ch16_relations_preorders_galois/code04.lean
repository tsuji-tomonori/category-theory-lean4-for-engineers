-- Source: chapters/ch16_relations_preorders_galois.tex:175

def DetailPreorder : PreorderMini Detail where
  le := detailLe
  refl := detail_refl
  trans := by
    intro a b c hab hbc
    exact detail_trans hab hbc

theorem no_secret_as_public :
    detailLe Detail.secretLevel Detail.publicLevel -> False := by
  intro h
  simpa [detailLe] using h
