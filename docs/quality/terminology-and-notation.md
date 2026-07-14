# 用語・記号規約

| 日本語 | 英語 | 記号・Lean | 規約・注意 | 初出 |
|---|---|---|---|---|
| 型 | type | `Type u` | 集合と無条件に同一視しない。universeを持つ | ch02 |
| 命題 | proposition | `Prop` | `Bool`による実行時判定と区別 | ch05 |
| 射 | morphism | `X ⟶ Y` | 型と関数の圏では関数。一般圏では関数とは限らない | ch11 |
| 合成 | composition | 数学 `g \circ f` / Mathlib `f ≫ g` | どちらも「先にf、次にg」 | ch11/ch40 |
| 同型 | isomorphism | `X ≅ Y` | 双方向関数だけでなく両逆を要求 | ch12 |
| 積・余積 | product/coproduct | `A × B`, `Sum A B` | 型構成子と一般圏の普遍性を区別 | ch13 |
| 関手 | functor | `C ⥤ D` | mapの存在だけでなく恒等・合成保存が必要 | ch14 |
| 自然変換 | natural transformation | `F ⟶ G` | 任意の採用した圏の射について自然性を要求 | ch15 |
| モノイド | monoid | `e`, `·` | モノイダル圏と区別 | ch16 |
| モノイダル圏 | monoidal category | `⊗`, `𝟙_` | tensorは実行時並列性や交換可能性を自動保証しない | ch16 |
| Galois接続 | Galois connection | `l a ≤ b ↔ a ≤ u b` | 採用する順序向きを式と図で固定 | ch22 |
| 引き戻し | pullback | `A ×_C B` | 存在、可換、一意性を要求 | ch23 |
| 随伴 | adjunction | `F ⊣ G` | Hom集合の自然同型。単なる全単射では不十分 | ch37 |
| 米田の補題 | Yoneda lemma | `Nat(Hom(A,-), F) ≅ F(A)` | 値の観測による分離補題と区別 | ch38 |
| トポス | topos | — | 本書では主にelementary toposの学習地図。一般DSLと同一視しない | ch39 |

外来語は、初出時に日本語と英語を併記します。
`adapter`、`join`、`lossless` などはコードまたは業界用語として原語を維持して構いませんが、数学用語との対応条件を別記します。
