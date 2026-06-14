-- Source: chapters/ch16_relations_preorders_galois.tex:251

inductive PublicView where
  | publicOnly
  | mayContainPrivate
deriving Repr, DecidableEq

-- publicOnly <= mayContainPrivate と読む。
def viewLe : PublicView -> PublicView -> Prop
  | .publicOnly, _ => True
  | .mayContainPrivate, .mayContainPrivate => True
  | .mayContainPrivate, .publicOnly => False

-- 抽象化: 詳細レベルを公開判定用の二段階へ落とす。
def erase : Detail -> PublicView
  | .publicLevel => .publicOnly
  | .internalLevel => .mayContainPrivate
  | .secretLevel => .mayContainPrivate

-- 具体化: 抽象ビューが許す最大の詳細レベルを見る。
def allow : PublicView -> Detail
  | .publicOnly => .publicLevel
  | .mayContainPrivate => .secretLevel
