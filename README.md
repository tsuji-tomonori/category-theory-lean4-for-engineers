# ソフトウェアエンジニアのための圏論と Lean 4 入門

圏論と Lean 4 を、仕様記述・同値性・安全なマイグレーションの観点から学ぶための書籍原稿リポジトリです。

## 構成

- `main.tex`: 書籍全体のエントリポイント
- `chapters/`: 各章の LaTeX 原稿
- `parts/`: 各部の導入文
- `lean/`: 章に対応する Lean 4 サンプル
- `tools/`: 原稿と Lean コードの整合性チェック用スクリプト

## PDF 生成

LuaLaTeX と `latexmk` が必要です。

```sh
make
```

生成物は `main.pdf` です。中間ファイルを削除する場合は次を実行します。

```sh
make clean
```

## Lean コードの確認

通常の Lean ファイルは次のように確認できます。

```sh
find lean -type f -name '*.lean' ! -name 'ch34_mathlib_category_theory.lean' -print0 \
  | sort -z \
  | while IFS= read -r -d '' file; do lean "$file"; done
```

`mathlib` を使う章はキャッシュ取得後に確認します。

```sh
lake update mathlib
lake exe cache get
lake env lean lean/ch34_mathlib_category_theory.lean
```

## 補助チェック

```sh
python3 tools/check_tex_lean_sync.py
python3 tools/check_listing_explanations.py
```
