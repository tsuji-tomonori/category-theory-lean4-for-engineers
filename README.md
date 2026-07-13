# ソフトウェアエンジニアのための圏論と Lean 4 入門

圏論と Lean 4 を、仕様記述・同値性・安全なマイグレーションの観点から学ぶための書籍原稿リポジトリです。

## 構成

- `main.tex`: 書籍全体のエントリポイント
- `chapters/`: 各章の LaTeX 原稿
- `parts/`: 各部の導入文
- `lean/`: 章ごとにディレクトリを分けた Lean 4 サンプル。本文のコードブロックごとに `codeNN.lean` を置く
- `tools/`: 原稿と Lean コードの整合性チェック用スクリプト

## PDF 生成

LuaLaTeX と `latexmk` が必要です。

```sh
make
```

生成物は `main.pdf` と、配布用に名前を付けた
`category-theory-lean4-for-engineers.pdf` です。`main` へ push すると、品質ゲートを通過した PDF が
GitHub Release に自動添付されます。リポジトリは公開されているため、GitHub の権限やログインなしで
[最新版 PDF](https://github.com/tsuji-tomonori/category-theory-lean4-for-engineers/releases/latest/download/category-theory-lean4-for-engineers.pdf)
をダウンロードできます。Git タグを push した場合も、同じ名前の PDF が対応する Release に添付されます。
中間ファイルを削除する場合は次を実行します。

```sh
make clean
```

## Lean コードの確認

本文のコードブロックごとに分けた `lean/<章名>/codeNN.lean` は、各ファイルを単独で確認します。

```sh
python3 tools/check_lean_snippets.py
```

`mathlib` を使う章を含めて確認する場合は、事前にキャッシュを取得します。

```sh
lake update mathlib
lake exe cache get
python3 tools/check_lean_snippets.py lean/ch40_mathlib_category_theory
```

## 補助チェック

```sh
python3 tools/check_tex_lean_sync.py
python3 tools/check_listing_explanations.py
```
