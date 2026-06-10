# AMBER分子動力学シミュレーション学習

AMBERチュートリアル（Introductory Case Studies）を完走した記録。
10塩基対 polyA-polyT DNA二重らせんを題材に、真空から陽溶媒まで段階的にMDシミュレーションを実施した。

## 環境

- **OS**: Ubuntu (PowerEdge T440)
- **MDソフトウェア**: AMBER 18 / AmberTools 19
- **力場**: BSC1 (DNA), TIP3P (水)
- **実行環境**: シングルコア CPU (sander)

## ディレクトリ構成
yazawa/
├── tutorial2/   # Section 2-5: B型 polyA-polyT DNAのMD
└── tutorial6/   # Section 6: A型DNAの応用例（A→B転移の観察）

## 学習内容（全6セクション）

### Section 2: 入力ファイル作成
- NABでB型DNA二重らせん（10-mer）を生成
- tleapで3モデル作成：
  - 真空モデル (`polyAT_vac`)
  - 真空＋Na+対イオン (`polyAT_cio`)
  - 水中モデル (`polyAT_wat`, TIP3P水3044分子, 切頂八面体ボックス)

### Section 3: 真空中MD
- 真空モデルで100ps MDを2本実行
- カットオフ12Å vs カットオフなしの比較
- **結果**: カットオフなしではリン酸基同士の静電反発でDNAが24.8psで爆発（35Å超のRMSd）
- **学び**: 真空シミュレーションは現実から乖離

### Section 4: 陰溶媒（GB模型）MD
- Generalized Born模型（`igb=1`）を導入
- 100ps × 2本を実行
- **結果**: カットオフ有無による違いがほぼ消失、両者とも安定（RMSd 2-4Å）
- **学び**: 水の効果を方程式に組み込むだけで劇的に安定化

### Section 5: 陽溶媒（TIP3P水）MD
- 周期境界＋PME法で本格シミュレーション
- 手順：
  1. 最小化（DNA固定 → 全体）
  2. 加熱 0K→300K（20ps、DNA弱拘束、SHAKE使用、dt=2fs）
  3. 平衡化（100ps、定圧1atm、拘束なし）
- **結果**: DNA主鎖RMSd 約1.9Åで安定、密度1.04 g/cm³、温度300K
- **学び**: 教科書目標値（RMSd < 2Å）を達成、最も現実的なシミュレーション

### Section 6: A型DNAの応用例
- A型DNA（`fd_helix("adna", ...)`）から開始
- 1.8 nsの長時間MDをスクリプトで自動実行（200ps × 9本連続）
- 全シミュレーション時間: 約38時間
- **結果**: 約400ps時点でA型→B型に自発転移、最終RMSd 約4.9Å
- **学び**: MDシミュレーションで局所安定構造（A型）から大域安定構造（B型）への移行を捉えられる

## 使用ツール

| ツール | 用途 |
|---|---|
| `nab` | DNA初期構造生成 |
| `tleap` | 力場適用、prmtop/rst7作成 |
| `sander` | MDシミュレーション本体 |
| `cpptraj` | トラジェクトリ解析（RMSd、平均構造、再イメージング） |
| `process_mdout.perl` | mdoutからエネルギー等を抽出 |
| `ambpdb` | rst7→PDB変換 |
| Excel | グラフ化（エネルギー、温度、密度、RMSd） |

## シミュレーション統計

| Section | 内容 | 計算時間 |
|---|---|---|
| 3 | 真空MD 100ps × 2 | 約10分 |
| 4 | GB MD 100ps × 2 | 約1時間 |
| 5 | 陽溶媒MD 加熱20ps + 平衡100ps | 約2時間 |
| 6 | A-DNA MD 1.8 ns | 約38時間 |

## 主な学び

1. **シミュレーション条件で結果は劇的に変わる**
   - 真空+カットオフあり: 見かけ上安定（人工的）
   - 真空+カットオフなし: 物理的に正しいが爆発
   - 陽溶媒: 現実的な挙動
2. **「計算が走った = 正しい結果」ではない**
3. **水とイオンを含む系の重要性**
4. **MDは局所平衡から大域平衡への構造変化も捉えられる**（A→B転移）

## 参考

- AMBER公式チュートリアル: http://ambermd.org/tutorials/basic/tutorial1/
- 力場参考文献: Ivani et al., *Nat. Methods* (2016) BSC1
- A↔B転移: Cheatham & Kollman, *J. Mol. Biol.* (1996) 259, 434-444