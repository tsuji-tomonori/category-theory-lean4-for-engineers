# 書籍品質契約

対象基準は `main` の対象コミットとし、各監査・改訂PRで対象SHAを記録する。

## Severity

- P0: 数学的に偽、Leanが壊れる、主張の向きが逆、重大な誤保証。発見時はリリース停止。
- P1: 必要仮定の欠落、中心概念の重大な誤解、根拠不足、前提知識の重大な飛躍。
- P2: 説明順、用語、コード説明、図、章間整合性。
- P3: 表現、レイアウト、軽微な統一。

## Claim分類

`DEF`, `THM`, `EX`, `NONEX`, `CONV`, `ANALOGY`, `LEAN`, `SCOPE` を使う。`LEAN` は記載された型・仮定・量化の範囲だけが検査済みであり、本番実装全体の保証を意味しない。

## 共通完了条件

### 数学

- 定義・定理に対象、量化、仮定、等式・不等式・合成の向きがある。
- 普遍性は存在、可換条件、一意性を別々に確認する。
- 特殊例、一般定理、直感、比喩、非例を区別する。
- P0/P1は数学担当と敵対的レビュー担当の両方がcloseする。

### Lean

- `lean-toolchain` と `lake-manifest.json` が固定する版で全スニペットが通る。
- 本文の主張とLean定理の仮定・量化・結論が一致する。
- `sorry`, `admit`, `axiom` は `tools/lean_assumption_allowlist.txt` に理由付きで登録された教材テンプレート以外0件。
- warningを黙って成功扱いしない。

### 教育

- 用語、記号、Lean構文を使用前または初出箇所で説明する。
- learning goalごとに章末の確認課題または自己説明課題を対応させる。
- 中心概念に非例または境界例と「保証しないこと」がある。
- 実読者テストとAI模擬レビューを混同しない。

### 比喩

- 数学側、software側、成立条件、対応しない点、誤って定理扱いした場合の失敗を記録する。
- モデル上の証明と本番DB/API/並行実行/外部状態の保証を分離する。

### 出典

- 中心 `DEF`/`THM` と全P0/P1に標準資料、公式資料、固定ソースのいずれかを割り当てる。
- 独自の説明・例と引用を区別する。
- bibliographyが空でなく、undefined citationが0件である。

### 図・PDF・CI

- release buildでは欠落画像をplaceholderにせず失敗させる。
- missing glyph、undefined reference/citation、multiply defined label、空bibliographyを0にする。
- 2ptを超えるoverfull boxは、行と理由と期限を持つallowlist以外0にする。
- release公開jobはLean、quality、PDF buildの全job成功を必須とする。

## Finding必須項目

Finding ID、Severity、File/line、Claim、Problem、Counterexample/edge case、Authoritative basis、Proposed resolution、Validation、Dependency、Estimate、Owner roleを必須とする。

## リリース停止条件

- 未解決P0/P1がある。
- 固定版Lean検査、品質検査、PDF buildのいずれかが失敗する。
- 必須の数学・Lean・初学者・出典・図版review証拠がない。
- 「証明済み」の範囲がclaim ledgerから追跡できない。
