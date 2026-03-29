# S3 Draft Ideas Restructure — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure S3 draft_ideas files from the old 8-paper layout (Paper #21–28) to the approved 13-paper design (S3-P01–P13), creating new files where needed and updating all headers and cross-references.

**Architecture:** The old 8-paper structure maps to the new 13-paper structure via reshuffling + splitting + new creation. P01–P04 keep their content (header updates only). P05–P08 old content shifts to P07/P08/P11/P12–P13. New P05 (第六意識) and P06 (前五識) are created from scratch. New P09 (根本煩惱+不定) and P10 (隨煩惱) are created by splitting old P06 content.

**Spec:** `docs/superpowers/specs/2026-03-29-s3-hundred-dharmas-design.md`

---

## Content Mapping

| New Paper | Title | Source | Action |
|-----------|-------|--------|--------|
| S3-P01 | 百法總綱 | existing S3-P01 | Update headers + cross-refs |
| S3-P02 | 三能變 | existing S3-P02 | Update headers + cross-refs |
| S3-P03 | 阿賴耶識 | existing S3-P03 | Update headers + cross-refs |
| S3-P04 | 末那識 | existing S3-P04 | Update headers + cross-refs |
| S3-P05 | 第六意識 | **NEW** | Create from spec + research assets |
| S3-P06 | 前五識 | **NEW** | Create from spec + research assets |
| S3-P07 | 遍行與別境 | old S3-P05 | Rename, remove 不定, update refs |
| S3-P08 | 善心所 | old S3-P06 | Rename, remove 煩惱, update refs |
| S3-P09 | 根本煩惱+不定 | **NEW** (from old P06 煩惱 + old P05 不定) | Create by extracting + expanding |
| S3-P10 | 隨煩惱 | **NEW** (from old P06 隨煩惱 section) | Create by extracting + expanding |
| S3-P11 | 色法+不相應行法 | old S3-P07 | Rename, update refs |
| S3-P12 | 無為法 | old S3-P08 (無為 half) | Create by splitting |
| S3-P13 | 轉識成智 | old S3-P08 (轉智 half) | Create by splitting |

---

### Task 1: Reshuffle existing files to new positions

**Files:**
- Rename: `series3_hundred-dharmas/S3-P05_draft_ideas.md` → `S3-P07_draft_ideas.md`
- Rename: `series3_hundred-dharmas/S3-P06_draft_ideas.md` → `S3-P08_draft_ideas.md`
- Rename: `series3_hundred-dharmas/S3-P07_draft_ideas.md` → `S3-P11_draft_ideas.md`
- Rename: `series3_hundred-dharmas/S3-P08_draft_ideas.md` → `S3-P13_draft_ideas.md`

The renames must happen in reverse order (highest number first) to avoid collisions.

- [ ] **Step 1: Rename in reverse order to avoid collisions**

```bash
cd /Users/master/Projects/dharma-research/series3_hundred-dharmas
mv S3-P08_draft_ideas.md S3-P13_draft_ideas.md
mv S3-P07_draft_ideas.md S3-P11_draft_ideas.md
mv S3-P06_draft_ideas.md S3-P08_draft_ideas.md
mv S3-P05_draft_ideas.md S3-P07_draft_ideas.md
```

- [ ] **Step 2: Verify file count and names**

```bash
ls -1 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P*_draft_ideas.md | sort
```

Expected: 8 files — P01, P02, P03, P04, P07, P08, P11, P13 (gaps at P05, P06, P09, P10, P12)

---

### Task 2: Update headers in P01–P04 (content unchanged, headers only)

**Files:**
- Modify: `series3_hundred-dharmas/S3-P01_draft_ideas.md` (line 1)
- Modify: `series3_hundred-dharmas/S3-P02_draft_ideas.md` (line 1)
- Modify: `series3_hundred-dharmas/S3-P03_draft_ideas.md` (line 1)
- Modify: `series3_hundred-dharmas/S3-P04_draft_ideas.md` (line 1)

For each file, update the `# Paper #NN` header to `# S3-P0N` format and update all cross-reference paper numbers throughout.

- [ ] **Step 1: Update S3-P01 header**

Change line 1 from:
```
# Paper #21 — 一切法無我：百法總綱
```
to:
```
# S3-P01 — 一切法無我：百法總綱
```

Update cross-references throughout the file:
- `Paper #22-28` → `S3-P02–P13`
- `Paper #1` → `S1-P01`
- `Paper #9` → `S1-P09`
- `Paper #13-14` → `S2-P03–P04`
- `本 Series Paper #22-28` → `S3-P02–P13：後續十二篇逐區深入`

- [ ] **Step 2: Update S3-P02 header**

Change line 1 from:
```
# Paper #22 — 八識全景：三能變
```
to:
```
# S3-P02 — 三能變：八識全景
```

Update cross-references: Paper #21→S3-P01, Paper #23→S3-P03, Paper #24→S3-P04, etc. Replace all `Paper #NN` with the corresponding `SX-PNN`.

- [ ] **Step 3: Update S3-P03 header**

Change line 1 from:
```
# Paper #23 — 阿賴耶識：生命的硬碟
```
to:
```
# S3-P03 — 阿賴耶識：生命的硬碟
```

Update cross-references throughout.

- [ ] **Step 4: Update S3-P04 header**

Change line 1 from:
```
# Paper #24 — 末那識：看不見的我執
```
to:
```
# S3-P04 — 末那識：看不見的我執
```

Update cross-references throughout.

- [ ] **Step 5: Verify all four files have correct headers**

```bash
head -1 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P0{1,2,3,4}_draft_ideas.md
```

Expected: `# S3-P01 —`, `# S3-P02 —`, `# S3-P03 —`, `# S3-P04 —`

---

### Task 3: Update reshuffled files (P07, P08, P11, P13) — headers, scope, cross-refs

**Files:**
- Modify: `series3_hundred-dharmas/S3-P07_draft_ideas.md` (was old P05 遍行+別境+不定)
- Modify: `series3_hundred-dharmas/S3-P08_draft_ideas.md` (was old P06 善+煩惱)
- Modify: `series3_hundred-dharmas/S3-P11_draft_ideas.md` (was old P07 色法+不相應)
- Modify: `series3_hundred-dharmas/S3-P13_draft_ideas.md` (was old P08 無為+轉智)

- [ ] **Step 1: Update S3-P07 (遍行與別境 — remove 不定)**

Change header from:
```
# Paper #25 — 遍行＋別境＋不定：心理引擎
## Universal, Object-Specific, and Indeterminate Mental Factors: The Psychological Engine
```
to:
```
# S3-P07 — 遍行與別境：心理引擎
## Universal and Object-Specific Mental Factors: The Psychological Engine
```

Update 核心論題: Remove 不定 references (不定 moves to P09).

Update 百法範圍: Remove 不定心所 4 section. Change 共 14 法 → 共 10 法.

Remove the 不定 subsections from 學術版 and 實踐版 material (惡作、睡眠、尋、伺 content). This content will be used in the new P09.

Update cross-references: all `Paper #NN` → `SX-PNN`.

Add new cross-ref to S3-P05 (第六意識): `作意回扣 S1-P06（覺察即轉向）——S3-P05 第六意識的照鏡子能力`

- [ ] **Step 2: Update S3-P08 (善心所 — remove 煩惱)**

Change header from:
```
# Paper #26 — 善心所＋煩惱：善惡的真相
## Wholesome and Afflictive Mental Factors: The Truth About Good and Evil
```
to:
```
# S3-P08 — 善心所：修行的燃料
## Wholesome Mental Factors: The Fuel for Practice
```

Update 核心論題: Focus on 善 11 only.

Update 百法範圍: Remove 煩惱 sections. Keep only 善心所 11.

Remove the 根本煩惱 and 隨煩惱 subsections from 學術版 and 實踐版 material. This content will be used in P09 and P10.

Add: 信 = S1 整個系列的心所基礎——S1「信」在百法中的精確定位.

Update cross-references: all `Paper #NN` → `SX-PNN`.

- [ ] **Step 3: Update S3-P11 (色法+不相應行法)**

Change header from:
```
# Paper #27 — 色法＋不相應行法：外面的世界
## Form and Factors Dissociated from Mind: The World Outside
```
to:
```
# S3-P11 — 色法與不相應行法：外面的世界
## Form Dharmas and Factors Dissociated from Mind: The World Outside
```

Update cross-references: all `Paper #NN` → `SX-PNN`.

- [ ] **Step 4: Update S3-P13 (轉識成智 — remove 無為法)**

Change header from:
```
# Paper #28 — 無為法＋轉識成智：回家
## Unconditioned Dharmas and the Transformation of Consciousness into Wisdom: Coming Home
```
to:
```
# S3-P13 — 轉識成智：回家
## Transformation of Consciousness into Wisdom: Coming Home
```

Update 核心論題: Remove 無為法 references (moves to P12).

Update 百法範圍: Remove 無為法 6 section. Focus on 轉識成智 + 二無我.

Remove the 六無為法 subsections from 學術版 and 實踐版 material. This content will be used in P12.

Update cross-references: all `Paper #NN` → `SX-PNN`. Update `Paper #21` → `S3-P01`, etc.

- [ ] **Step 5: Verify all four reshuffled files**

```bash
head -2 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P{07,08,11,13}_draft_ideas.md
```

Expected headers: `# S3-P07 —`, `# S3-P08 —`, `# S3-P11 —`, `# S3-P13 —`

---

### Task 4: Create S3-P05 (第六意識) draft_ideas

**Files:**
- Create: `series3_hundred-dharmas/S3-P05_draft_ideas.md`
- Reference: `research/hundred-dharmas/心法/意識/` (學術版 + 實踐版)
- Reference: spec P05 section

- [ ] **Step 1: Read research assets for 第六意識**

```bash
ls /Users/master/Projects/dharma-research/research/hundred-dharmas/心法/意識/
```

Read the academic and practice versions to extract key material.

- [ ] **Step 2: Create S3-P05_draft_ideas.md**

Write the file following the exact format of existing draft_ideas (see S3-P01 or S3-P03 for template). Must include all standard sections:

```markdown
# S3-P05 — 第六意識：唯一能照鏡子的識
## The Sixth Consciousness: The Only One That Can Look in the Mirror

### 核心論題 (Core Thesis)
第六意識是八識中唯一具備自我覺察能力的識——它能反觀自身的心理活動。
末那識恆常執我卻不知道自己在執，阿賴耶識儲藏一切卻沒有自覺，
前五識接收感官卻不知「是我在接收」。唯有第六意識能「照鏡子」，
這個能力既是修行的唯一入口（妙觀察智），也是造重業的根源（51心所全相應）。

### 百法範圍 (Hundred Dharmas Coverage)
- **心法：第六意識**（意識）
- 與 51 心所全部可相應——八識中唯一
- 共 1 法（深入展開）

### 八識規矩頌涵蓋 (Verses Covered)
第六意識三頌全展開：
- 第一頌（體性）：「三性三量通三境，三界輪時易可知，相應心所五十一，善惡臨時別配之」
- 第二頌（功能）：「性界受三恒轉易，根隨信等總相連，動身發語獨為最，引滿能招業力牽」
- 第三頌（轉依）：「發起初心歡喜地，俱生猶自現纏眠，遠行地後純無漏，觀察圓明照大千」

### 從學術版提取的關鍵素材 (Key Material from Academic Version)
[Extract from research/hundred-dharmas/心法/意識/ academic version]

### 從實踐版提取的素材 (Material from Practice Version)
[Extract from research/hundred-dharmas/心法/意識/ practice version]

### 從八識研究提取的素材 (Material from Eight Consciousnesses Research)
[Extract from research/hundred-dharmas/心法/綜合研究/]

### 經論引用預覽 (Scripture Citations Preview)
- **T1585 成唯識論**：卷五（第六意識的三類運作）；卷七（獨頭意識的四種）
- **八識規矩頌**：第六意識三頌

### 與其他 Papers 的關聯 (Cross-references)
- **S3-P02**：八識全景中第六意識的速寫→本篇完整展開
- **S3-P03**：阿賴耶識沒有自覺→對比第六意識的自覺能力
- **S3-P04**：末那識盲目執我→第六意識是唯一能察覺末那在執的識
- **S3-P06**：前五識取境→第六意識分別→形成完整認知鏈
- **S3-P07**：遍行別境心所→第六意識與全部51心所相應的展開
- **S1-P06**：覺察即轉向→第六意識的照鏡子能力是「覺察」的唯識精確定位

### 待 RAG 查詢 (RAG Queries Needed)
1. 成唯識論卷五第六意識的完整定義段落
2. 獨頭意識四種（獨散、夢中、定中、狂亂）的原文
3. 八識規矩頌第六意識三頌的傳統注疏
4. 「相應心所五十一，善惡臨時別配之」的義理展開
5. 見道「發起初心歡喜地」到「遠行地後純無漏」的修行次第
```

- [ ] **Step 3: Verify file created**

```bash
head -2 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P05_draft_ideas.md
```

Expected: `# S3-P05 — 第六意識：唯一能照鏡子的識`

---

### Task 5: Create S3-P06 (前五識) draft_ideas

**Files:**
- Create: `series3_hundred-dharmas/S3-P06_draft_ideas.md`
- Reference: `research/hundred-dharmas/心法/眼識/` through `身識/` (5 directories)
- Reference: spec P06 section

- [ ] **Step 1: Read research assets for 前五識**

```bash
ls /Users/master/Projects/dharma-research/research/hundred-dharmas/心法/眼識/
```

Read the academic and practice versions for each of the five sensory consciousnesses.

- [ ] **Step 2: Create S3-P06_draft_ideas.md**

Follow the same template format. Key content from spec:

```markdown
# S3-P06 — 前五識：感官的直接性
## The First Five Consciousnesses: The Directness of Sensory Experience

### 核心論題 (Core Thesis)
前五識（眼耳鼻舌身）是八識中最「誠實」的識——它們直接取境（現量）、
不帶名言、不加分別。但「眼見為實」是幻覺：你以為看到的是外境，
其實是前五識取境後經第六識分別、末那識執我的多層加工結果。
理解前五識的直接性，就理解了為什麼「回到感官」是禪修的基本方法。

### 百法範圍 (Hundred Dharmas Coverage)
- **心法：前五識**（眼識、耳識、鼻識、舌識、身識）
- 共 5 法

### 八識規矩頌涵蓋 (Verses Covered)
前五識三頌全展開（五識共用一組頌）：
- 第一頌（體性）：「性境現量通三性，眼耳身三二地居，遍行別境善十一，中二大八貪癡癡」
- 第二頌（功能）：「五識同依淨色根，九緣七八好相鄰，合三離二觀塵世，愚者難分識與根」
- 第三頌（轉依）：「變相觀空唯後得，果中猶自不詮真，圓明初發成所作，三類分身息苦輪」

### 經論引用預覽 (Scripture Citations Preview)
- **T1585 成唯識論**：卷五（前五識九緣生識）
- **T1579 瑜伽師地論**：卷五十四（九緣生識的完整展開）
- **八識規矩頌**：前五識三頌

### 與其他 Papers 的關聯 (Cross-references)
- **S3-P02**：八識全景中前五識的速寫→本篇完整展開
- **S3-P05**：第六意識→前五識取境後交給第六識分別
- **S3-P07**：遍行別境心所→前五識可相應的心所範圍
- **S3-P11**：色法→五根五境是前五識的所依和所緣

### 待 RAG 查詢 (RAG Queries Needed)
1. 成唯識論卷五前五識的各自定義
2. 九緣生識（瑜伽師地論卷五十四）的完整引文
3. 八識規矩頌前五識三頌的傳統注疏
4. 「合三離二觀塵世」的義理展開
5. 成所作智的完整論述
```

- [ ] **Step 3: Verify file created**

```bash
head -2 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P06_draft_ideas.md
```

Expected: `# S3-P06 — 前五識：感官的直接性`

---

### Task 6: Create S3-P09 (根本煩惱+不定) draft_ideas

**Files:**
- Create: `series3_hundred-dharmas/S3-P09_draft_ideas.md`
- Reference: `research/hundred-dharmas/心所有法/根本煩惱/` (6 directories)
- Reference: `research/hundred-dharmas/心所有法/不定/` (4 directories)
- Reference: Old S3-P07 (now P07) for 不定 content to extract
- Reference: Old S3-P08 (now P08) for 煩惱 content to extract

- [ ] **Step 1: Read research assets**

```bash
ls /Users/master/Projects/dharma-research/research/hundred-dharmas/心所有法/根本煩惱/
ls /Users/master/Projects/dharma-research/research/hundred-dharmas/心所有法/不定/
```

- [ ] **Step 2: Create S3-P09_draft_ideas.md**

Key content from spec:

```markdown
# S3-P09 — 根本煩惱與不定：輪迴的引擎
## Root Afflictions and Indeterminate Factors: The Engine of Samsara

### 核心論題 (Core Thesis)
六個根本煩惱（貪瞋癡慢疑惡見）是一切痛苦的源頭——它們不是偶爾出現的壞念頭，
而是深植在識中的結構性力量。四個不定心所（惡作、睡眠、尋、伺）則視因緣而定——
同一個心所可善可惡。將二者並置，是為了讓讀者看見：煩惱是確定惡的，
但不定心所提醒我們，心的某些活動本身無善惡，善惡取決於因緣。

### 百法範圍 (Hundred Dharmas Coverage)
- **根本煩惱 6**：貪、瞋、癡（無明）、慢、疑、惡見
  - 惡見分五：身見、邊見、邪見、見取見、戒禁取見
  - 五鈍使（貪瞋癡慢疑）+ 五利使（五見）
- **不定 4**：惡作、睡眠、尋、伺
- 共 10 法

### 與其他 Papers 的關聯 (Cross-references)
- **S3-P04**：末那識四煩惱常俱（我癡我見我慢我愛）是根本煩惱的「常駐版」
- **S3-P08**：善心所是根本煩惱的對治——三善根 vs 三毒
- **S3-P10**：隨煩惱全部依根本煩惱而起——本篇是因，P10 是果
- **S3-P07**：不定心所中的尋伺與別境心所中的慧的關係

### 待 RAG 查詢 (RAG Queries Needed)
1. 成唯識論卷六根本煩惱六的逐一定義原文
2. 五見（身見、邊見、邪見、見取見、戒禁取見）的完整展開
3. 五鈍使五利使在見道/修道中的斷除次第
4. 末那識四煩惱與根本煩惱六的關係論證
5. 不定四心所的三性判定原文（成唯識論卷七）
```

- [ ] **Step 3: Verify file created**

```bash
head -2 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P09_draft_ideas.md
```

---

### Task 7: Create S3-P10 (隨煩惱) draft_ideas

**Files:**
- Create: `series3_hundred-dharmas/S3-P10_draft_ideas.md`
- Reference: `research/hundred-dharmas/心所有法/隨煩惱/` (20 directories)

- [ ] **Step 1: Read research assets**

```bash
ls /Users/master/Projects/dharma-research/research/hundred-dharmas/心所有法/隨煩惱/
```

- [ ] **Step 2: Create S3-P10_draft_ideas.md**

Key content from spec:

```markdown
# S3-P10 — 隨煩惱：煩惱的枝末
## Secondary Afflictions: The Branches of Affliction

### 核心論題 (Core Thesis)
二十種隨煩惱全部依根本煩惱而起——它們是煩惱的「枝末」而非「根本」。
從小隨（各自獨立、情境性強）到中隨（一切不善心都有）到大隨（一切染污心都有），
染污範圍逐層擴大。理解這個結構，就理解了為什麼修行要「斷根」而不是「剪枝」。

### 百法範圍 (Hundred Dharmas Coverage)
- **小隨煩惱 10**：忿、恨、覆、惱、嫉、慳、誑、諂、害、憍
- **中隨煩惱 2**：無慚、無愧
- **大隨煩惱 8**：掉舉、昏沉、不信、懈怠、放逸、失念、散亂、不正知
- 共 20 法

### 與其他 Papers 的關聯 (Cross-references)
- **S3-P09**：根本煩惱是隨煩惱的「根」——本篇是枝末展開
- **S3-P08**：善心所中的慚愧 vs 隨煩惱中的無慚無愧——正反對照
- **S3-P05**：第六意識與全部煩惱心所相應——造業的主體

### 待 RAG 查詢 (RAG Queries Needed)
1. 成唯識論卷六隨煩惱二十的逐一定義原文
2. 小隨中隨大隨的分類依據原文
3. 無慚無愧「一切不善心都有」的論證
4. 大隨八「一切染污心都有」的論證
5. 隨煩惱與根本煩惱的依起關係
```

- [ ] **Step 3: Verify file created**

---

### Task 8: Create S3-P12 (無為法) draft_ideas

**Files:**
- Create: `series3_hundred-dharmas/S3-P12_draft_ideas.md`
- Reference: `research/hundred-dharmas/無為法/` (6 files)
- Reference: Old S3-P13 (which still contains 無為法 content from the original P08)

- [ ] **Step 1: Read research assets**

```bash
ls /Users/master/Projects/dharma-research/research/hundred-dharmas/無為法/
```

- [ ] **Step 2: Create S3-P12_draft_ideas.md by extracting 無為法 content from S3-P13**

Extract the 無為法 sections from the current S3-P13 file (which was the old P08 containing both 無為法 and 轉識成智). Create a standalone file:

```markdown
# S3-P12 — 無為法：百法的終點
## Unconditioned Dharmas: The Endpoint of the Hundred Dharmas

### 核心論題 (Core Thesis)
百法的最後六法與前九十四法根本不同——它們不生不滅、不是因緣造作的產物。
真如無為 = 圓成實性 = 一切法的真實面目。修行不是去「找到」真如，
而是去除對真如的遮蔽。

### 百法範圍 (Hundred Dharmas Coverage)
- **無為法 6**：虛空無為、擇滅無為、非擇滅無為、不動滅無為、想受滅無為、真如無為
- 共 6 法

[Extract remaining 學術版/實踐版 material from old S3-P13 無為法 sections]

### 解深密經引用
真如與三性的最終收束——圓成實性即真如無為。

### 與其他 Papers 的關聯 (Cross-references)
- **S3-P01**：百法總綱中五位百法的第五位→本篇完整展開
- **S3-P11**：色法不相應行法（有為）→ 本篇（無為）的轉折
- **S3-P13**：無為法是轉識成智的目標境界

### 待 RAG 查詢 (RAG Queries Needed)
1. 成唯識論卷十無為法六的完整定義
2. 真如無為與三性的關係論證
3. 擇滅 vs 非擇滅的區別原文
4. 想受滅無為（滅盡定）與阿賴耶識持身的關係
```

- [ ] **Step 3: Verify file created and S3-P13 still exists**

```bash
ls -1 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P1{2,3}_draft_ideas.md
```

Expected: both files exist.

---

### Task 9: Update README.md

**Files:**
- Modify: `series3_hundred-dharmas/README.md`

- [ ] **Step 1: Rewrite README to match new 13-paper structure**

Replace the entire content with:

```markdown
# Series 3：行 — 百法明門 · 解深密經 · 八識規矩頌

**Hundred Dharmas — Discovery of Boundless Treasure**

S3-P01–P13

---

## 系列簡介

三部典籍交織：《百法明門論》= 體（分類系統），《八識規矩頌》= 用（操作手冊），《解深密經》= 教（經典授權）。100 法 + 12 頌全部涵蓋。

從般若進入唯識：認識你的心的每一個零件，看見它們如何運作，然後轉識成智。

---

## 論文一覽

| # | 中文標題 | 狀態 |
|---|---------|------|
| S3-P01 | 一切法無我：百法總綱 | 構想 |
| S3-P02 | 三能變：八識全景 | 構想 |
| S3-P03 | 阿賴耶識：生命的硬碟 | 構想 |
| S3-P04 | 末那識：看不見的我執 | 構想 |
| S3-P05 | 第六意識：唯一能照鏡子的識 | 構想 |
| S3-P06 | 前五識：感官的直接性 | 構想 |
| S3-P07 | 遍行與別境：心理引擎 | 構想 |
| S3-P08 | 善心所：修行的燃料 | 構想 |
| S3-P09 | 根本煩惱與不定：輪迴的引擎 | 構想 |
| S3-P10 | 隨煩惱：煩惱的枝末 | 構想 |
| S3-P11 | 色法與不相應行法：外面的世界 | 構想 |
| S3-P12 | 無為法：百法的終點 | 構想 |
| S3-P13 | 轉識成智：回家 | 構想 |

---

*本目錄包含規劃文件、RAG 查詢素材及草稿構想。論文完稿統一存放於 [`papers/`](../papers/)。*
```

- [ ] **Step 2: Verify README**

```bash
grep -c "S3-P" /Users/master/Projects/dharma-research/series3_hundred-dharmas/README.md
```

Expected: 13+ matches (one per paper plus header references).

---

### Task 10: Final verification

- [ ] **Step 1: Verify all 13 draft_ideas files exist**

```bash
ls -1 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P*_draft_ideas.md | sort
```

Expected: 13 files, S3-P01 through S3-P13.

- [ ] **Step 2: Verify all headers are in new format**

```bash
for f in /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P*_draft_ideas.md; do
  echo "$(basename $f): $(head -1 $f)"
done
```

Expected: Every file starts with `# S3-PNN — ...` (no `Paper #NN` headers).

- [ ] **Step 3: Check for any remaining old-format references**

```bash
grep -r "Paper #[0-9]" /Users/master/Projects/dharma-research/series3_hundred-dharmas/*.md
```

Expected: No matches (all cross-references updated to SX-PNN format).

- [ ] **Step 4: File count validation**

```bash
echo -n "draft_ideas files: " && ls -1 /Users/master/Projects/dharma-research/series3_hundred-dharmas/S3-P*_draft_ideas.md | wc -l
echo -n "README exists: " && test -f /Users/master/Projects/dharma-research/series3_hundred-dharmas/README.md && echo "yes" || echo "no"
```

Expected: `draft_ideas files: 13`, `README exists: yes`

- [ ] **Step 5: Commit**

```bash
cd /Users/master/Projects/dharma-research
git add series3_hundred-dharmas/
git commit -m "重構 S3 百法明門：8 篇擴展為 13 篇結構

- P01-P04 更新標題編號和交叉引用
- 新增 P05 第六意識、P06 前五識
- P07-P08 從舊 P05-P06 拆分（移除不定/煩惱）
- 新增 P09 根本煩惱+不定、P10 隨煩惱
- P11 色法+不相應行法（舊 P07 更新）
- 新增 P12 無為法（從舊 P08 拆分）
- P13 轉識成智（舊 P08 拆分）
- README 更新為 13 篇結構

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
```
