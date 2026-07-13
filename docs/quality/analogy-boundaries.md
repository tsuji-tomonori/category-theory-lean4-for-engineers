# ソフトウェア比喩の境界

| 数学側 | software側 | 成立条件 | 対応しない点 | 誤一般化した場合の失敗 |
|---|---|---|---|---|
| 対象・射 | 型・純粋関数 | 対象を型、射をtotal pure functionに限定 | 例外、I/O、共有状態、部分関数 | 合成律が本番effectsまで保証すると誤認 |
| 同型 | schema相互変換 | 両方向がtotalで両round-trip成立 | 外部制約、時刻、欠損値、運用手順 | 双方向関数の存在だけでlosslessと判断 |
| 関手 | `List.map`等 | 恒等・合成保存を証明 | 任意の`map`風API | map関数があれば関手と判断 |
| 自然変換 | adapter | 採用した圏の全射について自然性 | metadata、effects、対象外処理 | adapterが全業務ロジックと干渉しないと誤認 |
| モノイダル積 | 処理の並置 | tensor bifunctorとcoherenceがある | 実行時並列、独立性、交換可能性 | raceや共有資源が安全と誤認 |
| モナド | 失敗・状態の合成 | 特定型構成子とpure/bindがlawsを満たす | 任意の非同期runtimeや外部効果 | 法則だけで再試行・取消・順序が安全と誤認 |
| Pullback | 共通keyによるjoin | key写像、集合意味、整合ペアと普遍性 | SQL NULL、bag、順序、重複、outer join | 行内分解の証明をDB join保証と誤認 |
| 米田 | interfaceによる観測 | 全Homと自然な観測を扱う | 部分interface、選択したobserverだけ | id observerを含む自明な分離をYoneda本体と誤認 |
| 内部言語 | context依存DSL | categorical semanticsを構成し必要構造を示す | 任意のtenant/context述語 | 一般DSLがtopos内部言語だと誤認 |
| 非単射変換 | 匿名化 | 明示した観測者モデル内での性質 | 補助情報、頻度、外部相関 | collision例だけでprivacyを保証 |
