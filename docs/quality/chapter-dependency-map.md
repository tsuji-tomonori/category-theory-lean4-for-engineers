# 章依存マップ

## 主経路

```text
ch00
  -> ch01 -> ch02 -> ch03 -> ch04 -> ch05 -> ch06 -> ch07 -> ch08
  -> ch09 -> ch10
  -> ch11 -> ch12 -> ch13 -> ch14 -> ch15 -> ch16 -> ch17
  -> ch18 -> ch19 -> ch20 -> ch21 -> ch22 -> ch23
  -> ch24 -> ch25 -> ch26
  -> ch27 -> ch28 -> ch29 -> ch30 -> ch31 -> ch32
  -> ch33 -> ch34 -> ch35 -> ch36
  -> ch37 -> ch38 -> ch39 -> ch40
```

## 重要な非線形依存

| 章 | 必須前提 | 理由 |
|---|---|---|
| ch13 | ch11, ch21の直感 | 積・余積の媒介射一意性と関数等式 |
| ch15/ch31 | ch11, ch14 | 関手間の自然性と合成方向 |
| ch17/ch34 | ch08, ch16 | 法則に基づく書き換えと結合律 |
| ch22 | ch05, ch07, ch11 | Prop、全称量化、前順序を圏として読む準備 |
| ch23/ch32 | ch13, ch21 | 普遍性と媒介射の一意性 |
| ch27〜30 | ch12, ch14, ch20 | 同型、関手則、リスト帰納法 |
| ch37 | ch16, ch20, ch22 | free monoid、fold、Galois接続 |
| ch38 | ch14, ch15, ch21 | Hom関手、自然変換、外延性 |
| ch39 | ch05, ch13, ch15 | 命題、有限極限・指数の語彙、自然性 |
| ch40 | ch11〜15, ch21 | 自作定義とMathlib APIの対応 |

## 使用前説明ゲート

各章の監査時に、本文中の数学用語、記号、Lean 構文を `docs/quality/terminology-and-notation.md` と照合します。
初出章が依存マップより後であれば、P1 として扱います。
