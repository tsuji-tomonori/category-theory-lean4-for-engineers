# 書籍品質契約

対象基準は `main` の対象コミットとし、各監査または改訂 PR で対象 SHA を記録します。

## Severity

- P0：数学的に偽である、Lean が壊れる、主張の向きが逆である、または重大な誤保証がある状態です。
  発見時にはリリースを停止します。
- P1：必要な仮定の欠落、中心概念の重大な誤解、根拠不足、または前提知識の重大な飛躍がある状態です。
- P2：説明順、用語、コード説明、図、章間整合性に関する問題です。
- P3：表現、レイアウト、軽微な統一に関する問題です。

## Claim分類

`DEF`、`THM`、`EX`、`NONEX`、`CONV`、`ANALOGY`、`LEAN`、`SCOPE` を使います。
`LEAN` は記載された型、仮定、量化の範囲だけが検査済みであり、本番実装全体の保証を意味しません。

## 共通完了条件

### 数学

- 定義と定理には、対象、量化、仮定、等式、不等式、合成の向きがあります。
- 普遍性について、存在、可換条件、一意性を別々に確認します。
- 特殊例、一般定理、直感、比喩、非例を区別します。
- P0 と P1 は、数学担当と敵対的レビュー担当の両方が close します。

### Lean

- `lean-toolchain` と `lake-manifest.json` が固定する版で、すべてのスニペットが通ります。
- 本文の主張と Lean 定理の仮定、量化、結論が一致します。
- `sorry`、`admit`、`axiom` は、`tools/lean_assumption_allowlist.txt` に理由付きで登録された教材テンプレートを除き、0件です。
- warning を黙って成功扱いしません。

### 教育

- 用語、記号、Lean 構文を、使用前または初出箇所で説明します。
- learning goal ごとに、章末の確認課題または自己説明課題を対応させます。
- 中心概念には、非例または境界例と「保証しないこと」があります。
- 実読者テストと AI 模擬レビューを混同しません。

### 比喩

- 数学側、software 側、成立条件、対応しない点、誤って定理として扱った場合の失敗を記録します。
- モデル上の証明と、本番 DB、API、並行実行、外部状態の保証とを分離します。

### 出典

- 中心的な `DEF` と `THM`、およびすべての P0 と P1 に、標準資料、公式資料、固定ソースのいずれかを割り当てます。
- 独自の説明および例と、引用とを区別します。
- bibliography が空ではなく、undefined citation が0件です。

### 図・PDF・CI

- release build では、欠落画像を placeholder にせず、ビルドを失敗させます。
- missing glyph、undefined reference/citation、multiply defined label、空の bibliography を0件にします。
- 2pt を超える overfull box は、行、理由、期限を持つ allowlist に含まれるものを除き、0件にします。
- release 公開 job は、Lean、quality、PDF build のすべての job が成功することを必須とします。

## Finding必須項目

Finding ID、Severity、File/line、Claim、Problem、Counterexample/edge case、Authoritative basis、Proposed resolution、Validation、Dependency、Estimate、Owner role を必須とします。

## リリース停止条件

- 未解決の P0 または P1 があります。
- 固定版 Lean 検査、品質検査、PDF build のいずれかが失敗しています。
- 必須の数学、Lean、初学者、出典、図版 review の証拠がありません。
- 「証明済み」の範囲を claim ledger から追跡できません。
