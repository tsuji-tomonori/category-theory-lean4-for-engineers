/-
Chapter 5: Category basics as types and functions.
This file contains the Lean snippets used in chapters/ch05_category.tex.
It intentionally avoids Mathlib's CategoryTheory API.
-/

namespace Ch05Category

-- 対象を型、射を関数として見る。
-- idFn は「何もしない処理」である。
def idFn {A : Type} (x : A) : A :=
  x

-- comp g f は「先に f、次に g」を実行する合成である。
def comp {A B C : Type} (g : B -> C) (f : A -> B) : A -> C :=
  fun x => g (f x)

-- 左から恒等処理を合成しても、結果は変わらない。
theorem id_left_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp idFn f x = f x := by
  rfl

-- 右から恒等処理を合成しても、結果は変わらない。
theorem id_right_pointwise {A B : Type} (f : A -> B) (x : A) :
    comp f idFn x = f x := by
  rfl

-- 三つの関数を合成するとき、括弧の付け方は結果に影響しない。
theorem comp_assoc_pointwise {A B C D : Type}
    (h : C -> D) (g : B -> C) (f : A -> B) (x : A) :
    comp (comp h g) f x = comp h (comp g f) x := by
  rfl

-- 例を小さくするため、文字列の長さをユーザーIDの代わりに使う。
def parseUserId (s : String) : Nat :=
  s.length

def fetchUserName (id : Nat) : String :=
  "user-" ++ toString id

def renderGreeting (name : String) : String :=
  "hello, " ++ name

-- 前半を後でまとめる見方。
def pipelineLeft : String -> String :=
  comp (comp renderGreeting fetchUserName) parseUserId

-- 後半を先にまとめる見方。
def pipelineRight : String -> String :=
  comp renderGreeting (comp fetchUserName parseUserId)

#eval pipelineLeft "abc"

-- 点ごとに見ると、両方のパイプラインは同じ式へ展開される。
theorem pipeline_assoc_pointwise (s : String) :
    pipelineLeft s = pipelineRight s := by
  rfl

-- calc を使うと、レビュー用の変形ログとして読める。
theorem pipeline_review_log (s : String) :
    pipelineLeft s = pipelineRight s := by
  calc
    pipelineLeft s
        = renderGreeting (fetchUserName (parseUserId s)) := by rfl
    _   = pipelineRight s := by rfl

-- 何もしない文字列処理。
def noOpString : String -> String :=
  idFn

-- no-op を最後に挟んだパイプライン。
def pipelineWithNoOp : String -> String :=
  comp noOpString pipelineLeft

-- 任意の入力で、no-op ありと no-op なしの結果は一致する。
theorem remove_noop_pointwise (s : String) :
    pipelineWithNoOp s = pipelineLeft s := by
  rfl

end Ch05Category
