-- Source: chapters/ch16_relations_preorders_galois.tex:227

def MonotoneMini {A B : Type}
    (leA : A -> A -> Prop) (leB : B -> B -> Prop)
    (f : A -> B) : Prop :=
  forall {x y}, leA x y -> leB (f x) (f y)
