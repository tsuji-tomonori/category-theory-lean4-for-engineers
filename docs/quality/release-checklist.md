# リリース品質チェックリスト

## 自動ゲート

- [ ] TeX–Lean strict sync
- [ ] listing説明構造
- [ ] Lean全スニペット、未許可warning 0
- [ ] `sorry`/`admit`/`axiom` allowlist外0
- [ ] citation、reference、label、bibliography
- [ ] 図版欠落・未参照・重複
- [ ] missing glyph、overfull、PDF metadata・size
- [ ] release jobが全quality jobへ依存
- [ ] `main` pushのReleaseにPDF、SHA-256、provenanceを添付
- [ ] 最新版PDFの匿名ダウンロードURLを確認

## 人手ゲート

- [ ] 数学担当が全P0/P1をclose
- [ ] Lean担当が本文と定理の強度を照合
- [ ] 初学者テストの実施記録と結果
- [ ] 比喩境界と本番保証範囲の確認
- [ ] 出典の一次性・固定版の確認
- [ ] 全図の矢印、ラベル、caption、縮小可読性
- [ ] 全PDFページのコード切れ、孤立見出し、目次、索引

## リリース記録

対象 SHA、Lean 版、Mathlib rev、PDF SHA-256、CI run、専門 review、初学者 review、既知の制限、未解決事項を release notes へ記録します。
未解決の P0 または P1 がある場合は、公開しません。
